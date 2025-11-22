//
//  ScanResultViewModel.swift
//  Wara
//
//  Created by Meow on 09/11/25
//

import Foundation
import SwiftUI

@MainActor
class ScanResultViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var data: ScanDataDTO?
    @Published var alternativeItems: [AlternativeProductItemDTO] = []
    @Published var isLoadingAlternatives: Bool = false
    @Published var selectedAlternativeDetail: AlternativeProductItemDTO?
    @Published var isLoadingAlternativeDetail: Bool = false
    @Published var alternativeDetailErrorMessage: String? = nil
    @Published var selectedAlternativeDetailData: AlternativeProductDetailDTO?
    @Published var scanRequestId: String?
    @Published var uploadedPhotoURL: String?

    private let remote = ScanRemoteSource.shared
    private let scanResultsRemote = ScanResultsRemoteSource.shared
    private let altRemote = AlternativeRemoteSource.shared

    // MARK: - Derived UI properties
    private func mapStatusToProductType(_ status: String) -> ProductType {
        switch status.lowercased() {
        case "kmf_certified":
            return .HALAL
        case "no_haram":
            return .SAFE_TO_CONSUME
        case "doubtful":
            return .DOUBTFULL
        case "haram":
            return .NON_HALAL
        default:
            return .SAFE_TO_CONSUME
        }
    }

    var productType: ProductType {
        guard let s = data?.status, !s.isEmpty else { return .SAFE_TO_CONSUME }
        return mapStatusToProductType(s)
    }

    var isKMF: Bool { data?.isKmf ?? false }

    // KMF Certificate details
    var kmfCertificateNo: String { data?.certificateNo ?? "" }
    var kmfCertificateValid: String { data?.certificateValid ?? "" }

    var imageURLs: [URL] {
        guard let d = data else { return [] }
        return [d.frontCoverURL, d.backCoverURL]
            .compactMap { $0 }
            .compactMap { URL(string: $0) }
    }

    var englishName: String { data?.englishName ?? "" }
    var koreanNameWithPronunciation: String {
        guard let d = data else { return "" }
        if let pron = d.koreanPronunciation, !pron.isEmpty {
            return "\(d.koreanName) (\(pron))"
        }
        return d.koreanName
    }
    var koreanName: String { data?.koreanName ?? "" }
    var koreanPronunciation: String { data?.koreanPronunciation ?? "" }

    var englishIngredients: String { data?.englishIngredients ?? "" }
    var facilityInfo: String { data?.facility?.englishDescription ?? data?.englishFacilityInfo ?? "" }
    var isFacilityInformed: Bool { data?.facility?.isInformed ?? false }
    var statusMessage: String { data?.statusMessage ?? "" }

    struct IngredientDisplayItem {
        let name: String
        let category: String
    }

    var listedIngredientsDisplay: [IngredientDisplayItem] {
        guard let d = data else { return [] }
        return d.listedIngridients.map { IngredientDisplayItem(name: $0.englishName, category: $0.category.lowercased()) }
    }

    var suspectedIngredientsEnglish: [String] {
        guard let d = data else { return [] }
        return d.listedIngridients
            .filter { ["doubtful", "not_safe"].contains($0.category.lowercased()) }
            .map { $0.englishName }
    }

    // Ingredients sections
    var listedIngredientsEnglish: [String] {
        guard let d = data else { return [] }
        return d.listedIngridients.map { $0.englishName }
    }

    var notListedIngredientsEnglish: [String] {
        guard let d = data else { return [] }
        return d.notListedIngridients.map { $0.englishName }
    }

    // More information section
    var englishProducent: String { data?.englishProducent ?? "" }
    var koreanProducent: String { data?.koreanProducent ?? "" }
    var englishProductCategory: String { data?.englishProductCategory ?? "" }
    var koreanProductCategoryWithPronunciation: String {
        guard let d = data else { return "" }
        if let pron = d.koreanProductCategoryPronunciation, !pron.isEmpty, let cat = d.koreanProductCategory {
            return "\(cat) (\(pron))"
        }
        return d.koreanProductCategory ?? ""
    }

    // MARK: - Actions
    func scan(rawOCRText: String) async {
        guard !rawOCRText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.errorMessage = "OCR text kosong"
            return
        }
        isLoading = true
        errorMessage = nil

        await withCheckedContinuation { continuation in
            let id = UUIDv7.generate()
            self.scanRequestId = id
            remote.scanProduct(id: id, rawOCRText: rawOCRText) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let payload):
                        self.data = payload
                        self.loadAlternatives()
                    case .failure(let err):
                        self.errorMessage = err.localizedDescription
                    }
                    self.isLoading = false
                    continuation.resume()
                }
            }
        }
    }

    func loadScanResultById(_ id: String) async {
        isLoading = true
        errorMessage = nil
        await withCheckedContinuation { continuation in
            scanResultsRemote.fetchScanResultDetail(id: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let payload):
                        self.data = payload
                        self.loadAlternatives()
                    case .failure(let err):
                        self.errorMessage = err.localizedDescription
                    }
                    self.isLoading = false
                    continuation.resume()
                }
            }
        }
    }

    /// Memuat alternatif produk berdasarkan kategori dari hasil scan.
    private func loadAlternatives() {
        // Gunakan kategori Korea jika tersedia; fallback ke Inggris.
        let category = data?.koreanProductCategory?.trimmingCharacters(in: .whitespacesAndNewlines)
            ?? data?.englishProductCategory?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let category, !category.isEmpty else { return }
        isLoadingAlternatives = true

        altRemote.fetchAlternatives(category: category, paginate: 5) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.alternativeItems = items
                    self.isLoadingAlternatives = false
                case .failure:
                    self.alternativeItems = []
                    self.isLoadingAlternatives = false
                }
            }
        }
    }

    func loadAlternativeDetail(id: String, isKmf: Bool, completion: ((Result<AlternativeProductItemDTO, NetworkError>) -> Void)? = nil) {
        let categoryParam = isKmf ? "kmf" : "non_kmf"
        isLoadingAlternativeDetail = true
        alternativeDetailErrorMessage = nil
        altRemote.fetchAlternativeDetail(id: id, category: categoryParam) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let item):
                    self.selectedAlternativeDetail = item
                    self.isLoadingAlternativeDetail = false
                case .failure(let err):
                    self.selectedAlternativeDetail = nil
                    self.alternativeDetailErrorMessage = err.localizedDescription
                    self.isLoadingAlternativeDetail = false
                }
                completion?(result)
            }
        }

        altRemote.fetchAlternativeDetailData(id: id, category: categoryParam) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self.selectedAlternativeDetailData = detail
                case .failure:
                    self.selectedAlternativeDetailData = nil
                }
            }
        }
    }

    func uploadCapturedPhoto(image: UIImage?, packagingLabel: String, preferJPEG: Bool = true) {
        guard let image = image, let id = scanRequestId else { return }
        var data: Data? = nil
        var ext: String = "png"
        if preferJPEG, let jpeg = image.jpegData(compressionQuality: 0.85) {
            data = jpeg
            ext = "jpg"
        } else if let png = image.pngData() {
            data = png
            ext = "png"
        }
        guard let payload = data else { return }
        let fileName = "scan_\(packagingLabel)_\(id).\(ext)"
        scanResultsRemote.uploadScanPhoto(scanResultId: id, imageData: payload, fileName: fileName, packagingLabel: packagingLabel) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let dto):
                    self.uploadedPhotoURL = dto.url
                case .failure:
                    break
                }
            }
        }
    }
}