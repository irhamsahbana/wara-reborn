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

    private let remote = ScanRemoteSource.shared

    // MARK: - Derived UI properties
    var productType: ProductType {
        guard let d = data else { return .SAFE_TO_CONSUME }
        if d.isKmf { return .HALAL }
        // If any doubtful ingredient exists, mark as DOUBTFULL
        let hasDoubtful = d.listedIngridients.contains { $0.category.lowercased() == "doubtful" }
        if hasDoubtful { return .DOUBTFULL }
        return .SAFE_TO_CONSUME
    }

    var isKMF: Bool { data?.isKmf ?? false }

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

    var englishIngredients: String { data?.englishIngredients ?? "" }
    var facilityInfo: String { data?.facility?.englishDescription ?? data?.englishFacilityInfo ?? "" }
    var isFacilityInformed: Bool { data?.facility?.isInformed ?? false }

    var suspectedIngredientsEnglish: [String] {
        guard let d = data else { return [] }
        return d.listedIngridients
            .filter { $0.category.lowercased() == "doubtful" }
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
            remote.scanProduct(rawOCRText: rawOCRText) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let payload):
                        self.data = payload
                    case .failure(let err):
                        self.errorMessage = err.localizedDescription
                    }
                    self.isLoading = false
                    continuation.resume()
                }
            }
        }
    }
}