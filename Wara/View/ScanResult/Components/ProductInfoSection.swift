//
//  ProductInfoSection.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI
import UIKit

/// Product information section showing images, name, and status
struct ProductInfoSection: View {
    let isKMF: Bool
    let imageURLs: [URL]
    let fallbackImage: UIImage?
    let englishName: String
    let koreanName: String
    let koreanPronunciation: String
    let productType: ProductType
    let statusMessage: String
    
    var body: some View {
        CardView(backgroundColor: Color("chipBackground"), width: .infinity) {
            VStack {
                RemoteImageCarouselView(
                    isHalalKMF: isKMF,
                    imageURLs: imageURLs,
                    fallbackImage: fallbackImage
                )

                VStack(spacing: 4) {
                    Text(englishName)
                        .font(.body.weight(.semibold))
                        .foregroundColor(.primary)
                        .padding(.top, 10)

                    VStack(spacing: 2) {
                        Text(koreanName)
                            .font(.body)
                            .foregroundColor(.primary)
                        if !koreanPronunciation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text(koreanPronunciation)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }

                ResultInfoCard(productType: productType, statusMessage: statusMessage)
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ScrollView {
        ProductInfoSection(
            isKMF: true,
            imageURLs: [URL(string: "https://picsum.photos/300/200")!],
            fallbackImage: nil,
            englishName: "Strawberry Sticky Rice Cake",
            koreanName: "딸기 찹쌀떡",
            koreanPronunciation: "ttal-gi chap-ssal-tteok",
            productType: .HALAL,
            statusMessage: "This product is certified Halal by KMF"
        )
    }
    .background(Color("background"))
}
