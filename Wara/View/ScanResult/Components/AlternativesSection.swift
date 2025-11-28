//
//  AlternativesSection.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI

/// Section showing alternative/similar products
struct AlternativesSection: View {
    let isKMF: Bool
    let productType: ProductType
    let isLoading: Bool
    let items: [AlternativeProductItemDTO]
    let onToggleFavorite: (String, Bool) -> Void
    let onTapItem: (String, Bool, @escaping (Bool) -> Void) -> Void
    
    var body: some View {
        CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity) {
            VStack(alignment: .leading) {
                Text(isKMF || productType == .SAFE_TO_CONSUME ? "Other Product you Might Try:" : "Alternative Products:")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)

                if isLoading {
                    HStack {
                        ProgressView()
                        Text("Loading alternatives…")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                } else if items.isEmpty {
                    Text("No alternatives found")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(items) { item in
                                AlternativeProductCard(
                                    id: item.id,
                                    title: item.englishName,
                                    subtitle: item.koreanCategory,
                                    imageURL: URL(string: item.frontCoverURL ?? ""),
                                    isHalalKMF: item.isKmf,
                                    isFavorited: item.isFavorited,
                                    onFavoriteTapped: {
                                        onToggleFavorite(item.id, item.isKmf)
                                    }
                                )
                                .onTapGesture {
                                    onTapItem(item.id, item.isKmf) { _ in }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ScrollView {
        AlternativesSection(
            isKMF: true,
            productType: .HALAL,
            isLoading: false,
            items: [
                AlternativeProductItemDTO(
                    id: "1",
                    isKmf: true,
                    isFavorited: false,
                    englishCategory: "Rice Cake",
                    koreanCategory: "Rice Cake",
                    englishName: "Strawberry Rice Cake",
                    frontCoverURL: "https://picsum.photos/200/200?1",
                    backCoverURL: nil,
                    favoriteCounter: 0
                ),
                AlternativeProductItemDTO(
                    id: "2",
                    isKmf: true,
                    isFavorited: true,
                    englishCategory: "Rice Cake",
                    koreanCategory: "Rice Cake",
                    englishName: "Mango Rice Cake",
                    frontCoverURL: "https://picsum.photos/200/200?2",
                    backCoverURL: nil,
                    favoriteCounter: 0
                )
            ],
            onToggleFavorite: { _, _ in },
            onTapItem: { _, _, _ in }
        )
    }
    .background(Color("background"))
}
