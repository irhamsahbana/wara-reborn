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

    @StateObject private var scanResultViewModel = ScanResultViewModel()
    @State private var showAlternativeDetail = false
    @State private var productCandidates: [ProductCandidateDTO] = []

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                CustomAppBar(title: "Result", onBack: { onBack() }, onFavorite: {}, isFavoriteEnabled: false)
                    .background(Color("waraBackground"))

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        CardView(backgroundColor: Color("waraChipBackground"), aligment: .center, width: .infinity) {
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

                        if productCandidates.isEmpty {
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
                                ForEach(productCandidates) { candidate in
                                    AlternativeProductCard(
                                        id: candidate.id,
                                        title: candidate.englishName ?? "",
                                        subtitle: candidate.koreanCategory ?? candidate.englishCategory ?? "",
                                        imageURL: URL(string: candidate.frontCoverURL ?? ""),
                                        isHalalKMF: candidate.isKmf ?? false,
                                        isFavorited: candidate.isFavorited ?? false,
                                        onFavoriteTapped: {
                                            toggleFavorite(candidateId: candidate.id ?? "")
                                        }
                                    )
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        let isKmf = candidate.isKmf ?? false
                                        scanResultViewModel.loadAlternativeDetail(id: candidate.id ?? "", isKmf: isKmf) { _ in
                                            showAlternativeDetail = true
                                        }
                                    }
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
            .buttonStyle(PrimaryButtonStyle(backgroundColor: Color("waraPrimary")))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showAlternativeDetail) {
            VStack(spacing: 12) {
                if scanResultViewModel.isLoadingAlternativeDetail {
                    ProgressView()
                        .padding()
                } else if let detail = scanResultViewModel.selectedAlternativeDetailData {
                    AlternativeDetailView(detail: detail, fallbackImage: fallbackImage)
                } else {
                    Text(scanResultViewModel.alternativeDetailErrorMessage ?? "Failed to load alternative product")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            productCandidates = candidates
        }
    }
    
    private func toggleFavorite(candidateId: String) {
        guard let index = productCandidates.firstIndex(where: { $0.id == candidateId }) else { return }
        let candidate = productCandidates[index]
        let isKmf = candidate.isKmf ?? false
        
        // Update local state immediately for UI responsiveness
        productCandidates[index].isFavorited = !(candidate.isFavorited ?? false)
        
        // Call API to toggle favorite in background
        scanResultViewModel.toggleFavorite(itemId: candidateId, isKmf: isKmf)
    }
}

#Preview {
    let items: [ProductCandidateDTO] = [
        ProductCandidateDTO(id: "1", englishName: "Strawberry Sticky Rice Cake", englishCategory: "Rice Cake", koreanCategory: nil, frontCoverURL: "https://picsum.photos/200/200?1", backCoverURL: nil, isKmf: true, status: "kmf_certified", isFavorited: false),
        ProductCandidateDTO(id: "2", englishName: "Mango Sticky Rice Cake", englishCategory: "Rice Cake", koreanCategory: nil, frontCoverURL: "https://picsum.photos/200/200?2", backCoverURL: nil, isKmf: true, status: "kmf_certified", isFavorited: true),
        ProductCandidateDTO(id: "3", englishName: "Melon Sticky Rice Cake", englishCategory: "Rice Cake", koreanCategory: nil, frontCoverURL: "https://picsum.photos/200/200?3", backCoverURL: nil, isKmf: true, status: "safe", isFavorited: false),
        ProductCandidateDTO(id: "4", englishName: "Blueberry Sticky Rice Cake", englishCategory: "Rice Cake", koreanCategory: nil, frontCoverURL: "https://picsum.photos/200/200?4", backCoverURL: nil, isKmf: true, status: "safe", isFavorited: true)
    ]
    ScanResultFrontView(onBack: {}, onCaptureBack: {}, imageURL: URL(string: "https://picsum.photos/300/200"), fallbackImage: nil, candidates: items)
}
