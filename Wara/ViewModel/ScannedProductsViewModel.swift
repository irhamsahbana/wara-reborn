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
        let status: ProductType
        let isKmf: Bool
    }

    @Published var items: [ScannedProductGridItem] = []

    func loadCandidates(_ candidates: [ProductCandidateDTO]) {
        items = candidates.map { candidate in
            let id = candidate.id ?? UUID().uuidString
            let name = (candidate.englishName ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let categoryRaw = candidate.englishCategory ?? candidate.koreanCategory ?? ""
            let category = categoryRaw.trimmingCharacters(in: .whitespacesAndNewlines)
            let urlString = candidate.frontCoverURL ?? candidate.backCoverURL
            let url = URL(string: urlString ?? "")
            let status = mapStatus(candidate.status, isKmf: candidate.isKmf)
            let isKmf = candidate.isKmf ?? false
            return ScannedProductGridItem(id: id, englishName: name, category: category, imageURL: url, status: status, isKmf: isKmf)
        }
    }

    private func mapStatus(_ status: String?, isKmf: Bool?) -> ProductType {
        if isKmf == true { return .HALAL }
        switch status?.lowercased() {
        case "kmf_certified", "halal": return .HALAL
        case "safe", "no_haram", "safe_to_consume": return .SAFE_TO_CONSUME
        case "doubtful": return .DOUBTFULL
        case "haram", "non_halal": return .NON_HALAL
        default: return .DOUBTFULL
        }
    }
}
