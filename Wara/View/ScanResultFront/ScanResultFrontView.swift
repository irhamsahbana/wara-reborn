//
//  ScanResultFrontView.swift
//  Wara
//
//  Created by Meow on 12/11/25
//

import SwiftUI
import UIKit

struct ScanResultFrontView: View {
    let onBack: () -> Void
    let onCaptureBack: () -> Void
    let imageURL: URL?
    let fallbackImage: UIImage?
    let candidates: [ProductCandidateDTO]

    @StateObject private var viewModel = ScannedProductsViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                CustomAppBar(title: "Result", onBack: { onBack() }, onFavorite: {}, isFavoriteEnabled: false)
                    .background(Color("background"))

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        CardView(backgroundColor: Color("chipBackground"), aligment: .center, width: .infinity) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .frame(height: 140)
                                if let url = imageURL {
                                    CachedRemoteImageView(id: "front-image", url: url, contentMode: .fit, cornerRadius: 12)
                                        .frame(height: 120)
                                        .padding(.horizontal, 12)
                                } else if let img = fallbackImage {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 120)
                                        .padding(.horizontal, 12)
                                } else {
                                    Image("PackagedFoodFront")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 120)
                                        .padding(.horizontal, 12)
                                }
                            }
                        }
                        .padding(.horizontal, 16)

                        Text("Similar Products")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)

                        if viewModel.items.isEmpty {
                            VStack(spacing: 16) {
                                Image("girlNotFound")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 160)

                                Text("Oops! We couldn’t detect this front package.\nTry scanning the back of the product where the ingredients are listed.")
                                    .font(.body.weight(.semibold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 24)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 24)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                        } else {
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(viewModel.items) { item in
                                    AlternativeProductCard(
                                        id: item.id,
                                        title: item.englishName,
                                        subtitle: item.category,
                                        imageURL: item.imageURL,
                                        isHalalKMF: item.isKmf,
                                        likes: 0,
                                        onFavoriteTapped: nil
                                    )
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .safeAreaInset(edge: .bottom) {
            Button("Capture Back Packaging") {
                onCaptureBack()
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: Color("primaryblue")))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            viewModel.loadCandidates(candidates)
        }
    }
}

#Preview {
    let items: [ProductCandidateDTO] = [
        ProductCandidateDTO(id: "1", englishName: "Strawberry Sticky Rice Cake", englishCategory: "Rice Cake", koreanCategory: nil, frontCoverURL: "https://picsum.photos/200/200?1", backCoverURL: nil, isKmf: true, status: "kmf_certified"),
        ProductCandidateDTO(id: "2", englishName: "Mango Sticky Rice Cake", englishCategory: "Rice Cake", koreanCategory: nil, frontCoverURL: "https://picsum.photos/200/200?2", backCoverURL: nil, isKmf: true, status: "kmf_certified"),
        ProductCandidateDTO(id: "3", englishName: "Melon Sticky Rice Cake", englishCategory: "Rice Cake", koreanCategory: nil, frontCoverURL: "https://picsum.photos/200/200?3", backCoverURL: nil, isKmf: true, status: "safe"),
        ProductCandidateDTO(id: "4", englishName: "Blueberry Sticky Rice Cake", englishCategory: "Rice Cake", koreanCategory: nil, frontCoverURL: "https://picsum.photos/200/200?4", backCoverURL: nil, isKmf: true, status: "safe")
    ]
    return ScanResultFrontView(onBack: {}, onCaptureBack: {}, imageURL: URL(string: "https://picsum.photos/300/200"), fallbackImage: nil, candidates: items)
}
