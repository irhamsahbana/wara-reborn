//
//  ScannedProductsViewModel.swift
//  Wara
//
//  Created by Meow on 12/11/25
//

import Foundation
import SwiftUI

@MainActor
final class ScannedProductsViewModel: ObservableObject {
    struct ScannedProductGridItem: Identifiable {
        let id: String
        let englishName: String
        let category: String
        let imageURL: URL?
        let status: ProductTypeV2
        let isKmf: Bool
    }

    @Published var items: [ScannedProductGridItem] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String? = nil

    private let remote = ScanResultsRemoteSource.shared

    private var currentQuery: String = ""
    private var currentPage: Int = 1
    private var paginate: Int = 20
    private var totalPage: Int = 1

    func configureDefaultPaginate(_ value: Int) {
        paginate = value
    }

    func resetAndLoadInitial(query: String) {
        currentQuery = query
        currentPage = 1
        totalPage = 1
        items = []
        isLoading = true
        errorMessage = nil
        remote.fetchScanResults(query: query, page: currentPage, paginate: paginate) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let payload):
                    self.totalPage = payload.meta.totalPage
                    self.items = payload.items.map { dto in
                        let url = self.preferredCoverURL(front: dto.frontCoverURL, back: dto.backCoverURL)
                        let status = self.mapStatusV2(dto.status)
                        return ScannedProductGridItem(
                            id: dto.id,
                            englishName: dto.englishName,
                            category: dto.englishProductCategory,
                            imageURL: url,
                            status: status,
                            isKmf: status == .kmf_certified
                        )
                    }
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }

    func loadNextPageIfNeeded(currentItemId: String) {
        guard !isLoadingMore else { return }
        guard currentPage < totalPage else { return }
        let threshold = 6
        if let index = items.firstIndex(where: { $0.id == currentItemId }), index >= items.count - threshold {
            isLoadingMore = true
            let nextPage = currentPage + 1
            remote.fetchScanResults(query: currentQuery, page: nextPage, paginate: paginate) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isLoadingMore = false
                    switch result {
                    case .success(let payload):
                        self.currentPage = nextPage
                        self.totalPage = payload.meta.totalPage
                        let newItems = payload.items.map { dto in
                            let url = self.preferredCoverURL(front: dto.frontCoverURL, back: dto.backCoverURL)
                            let status = self.mapStatusV2(dto.status)
                            return ScannedProductGridItem(
                                id: dto.id,
                                englishName: dto.englishName,
                                category: dto.englishProductCategory,
                                imageURL: url,
                                status: status,
                                isKmf: status == .kmf_certified
                            )
                        }
                        self.items.append(contentsOf: newItems)
                    case .failure(let err):
                        self.errorMessage = err.localizedDescription
                    }
                }
            }
        }
    }

    func loadCandidates(_ candidates: [ProductCandidateDTO]) {
        items = candidates.map { candidate in
            let id = candidate.id ?? UUID().uuidString
            let name = (candidate.englishName ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let categoryRaw = candidate.englishCategory ?? candidate.koreanCategory ?? ""
            let category = categoryRaw.trimmingCharacters(in: .whitespacesAndNewlines)
            let url = preferredCoverURL(front: candidate.frontCoverURL, back: candidate.backCoverURL)
            let status = mapStatusV2(candidate.status)
            let isKmf = (candidate.isKmf == true) || status == .kmf_certified
            return ScannedProductGridItem(id: id, englishName: name, category: category, imageURL: url, status: status, isKmf: isKmf)
        }
    }

    private func mapStatusV2(_ status: String?) -> ProductTypeV2 {
        switch status?.lowercased() {
        case "kmf_certified", "halal": return .kmf_certified
        case "no_haram", "safe", "safe_to_consume": return .no_haram
        case "doubtful": return .doubtful
        case "haram", "non_halal": return .haram
        default: return .doubtful
        }
    }

    private func sanitizeURLString(_ raw: String?) -> String? {
        guard var s = raw?.trimmingCharacters(in: .whitespacesAndNewlines), !s.isEmpty else { return nil }
        s = s.replacingOccurrences(of: "`", with: "")
        s = s.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !s.isEmpty else { return nil }
        return s
    }

    private func preferredCoverURL(front: String?, back: String?) -> URL? {
        if let fs = sanitizeURLString(front), let url = URL(string: fs) { return url }
        if let bs = sanitizeURLString(back), let url = URL(string: bs) { return url }
        return nil
    }
}
