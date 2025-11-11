//
//  ResultView.swift
//  Wara
//
//  Created by Meow on 30/10/25.
//

import SwiftUI
import UIKit

// Animated gradient progress bar used during scanning
private struct ProgressGradientBar: View {
    let progress: Double // 0.0 ... 1.0

    private var clamped: Double { max(0.0, min(progress, 1.0)) }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color("green2"), Color("yellow")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * clamped)
            }
        }
        .frame(height: 12)
    }
}

struct ScanResultView: View {
    let onDismiss: () -> Void
    let rawOCRText: String
    let fallbackImage: UIImage?

    @StateObject private var viewModel = ScanResultViewModel()
    @State private var showSheet = false
    @State private var loadingProgress: Double = 0.0
    @State private var loadingTimer: Timer?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                CustomAppBar(
                    onBack: { onDismiss() },
                    onFavorite: { print("Favorite tapped") }
                )
                
                if viewModel.isLoading && viewModel.data == nil {
                    VStack(spacing: 16) {
                        Image("girlSearching")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 140)

                        VStack(spacing: 6) {
                            Text("Analyzing ingredients carefully...")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                            Text("This might take just a few seconds!")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                        }

                        ProgressGradientBar(progress: loadingProgress)
                            .padding(.horizontal, 24)
                            .animation(.easeInOut(duration: 0.25), value: loadingProgress)
                    }
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if let err = viewModel.errorMessage, viewModel.data == nil {
                    VStack(spacing: 12) {
                        Text(err)
                            .font(.body)
                            .foregroundColor(.primary)
                        Button("Back") {
                            onDismiss()
                        }
                        .buttonStyle(PrimaryButtonStyle(backgroundColor: Color("primaryblue")))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView{
                        CardView(backgroundColor: Color("chipBackground"), width: .infinity){
                            VStack{
                                RemoteImageCarouselView(
                                    isHalalKMF: viewModel.isKMF,
                                    imageURLs: viewModel.imageURLs,
                                    fallbackImage: fallbackImage
                                )

                                VStack(spacing: 4) {
                                    Text(viewModel.englishName)
                                        .font(.body.weight(.semibold))
                                        .foregroundColor(.primary)
                                        .padding(.top, 10)

                                    VStack(spacing: 2) {
                                        Text(viewModel.koreanName)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        if !viewModel.koreanPronunciation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Text(viewModel.koreanPronunciation)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }

                                ResultInfoCard(productType: viewModel.productType)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)

                    // Suspected Ingredients (on top when Doubtful or Non-Halal)
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        if(viewModel.productType == ProductType.DOUBTFULL || viewModel.productType == ProductType.NON_HALAL){
                            VStack(alignment: .leading, spacing: 12){
                                Text("Suspected Ingredients:")
                                    .font(.title3.weight(.semibold))
                                    .foregroundColor(.primary)

                                Text(viewModel.suspectedIngredientsEnglish.joined(separator: ", "))
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    
                    // Ingredient
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        VStack(alignment: .leading, spacing: 8){
                            Text("Ingredients:")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            if !viewModel.englishIngredients.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text(viewModel.englishIngredients)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }

                            if !viewModel.listedIngredientsEnglish.isEmpty {
                                Text("Listed Ingredients:")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.primary)

                                Text(viewModel.listedIngredientsEnglish.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }

                            if !viewModel.notListedIngredientsEnglish.isEmpty {
                                Text("Not Listed Ingredients:")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.primary)

                                Text(viewModel.notListedIngredientsEnglish.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }

                            if viewModel.isFacilityInformed {
                                Text("Manufactured with same Facility :")
                                    .font(.title3.weight(.semibold))
                                    .foregroundColor(.primary)
                                    .padding(.top, 8)
                                
                                Text(viewModel.facilityInfo)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)

                    // Certificate / Status
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        if viewModel.isKMF {
                            VStack(alignment: .leading, spacing: 12){
                                Text("Certificate No:")
                                    .font(.title3.weight(.semibold))
                                    .foregroundColor(.primary)

                                Text(viewModel.kmfCertificateNo)
                                    .font(.caption)
                                    .foregroundColor(.primary)

                                Text("Certificate Valid:")
                                    .font(.title3.weight(.semibold))
                                    .foregroundColor(.primary)

                                Text(viewModel.kmfCertificateValid)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }

                        if(viewModel.productType == ProductType.SAFE_TO_CONSUME){
                            VStack(alignment: .center, spacing: 12){
                                Text("Looks like this product’s new to us! ")
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(.primary)

                                Text("Sharing this product to Wara, Your contribution help others find safer food choices that align with halal principles.")
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)

                                Button("Share to Wara") {
                                    showSheet.toggle()
                                }
                                .buttonStyle(PrimaryButtonStyle(
                                    backgroundColor: Color("primaryblue")
                                ))
                                .padding(.top, 4)
                            }
                        }

                        // Suspected Ingredients moved to its own card above
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)

                    // Alternative Product
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        VStack(alignment: .leading){
                            Text(viewModel.isKMF || viewModel.productType == .SAFE_TO_CONSUME ? "Other Product you Might Try:" : "Alternative Products:")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.primary)

                            if viewModel.isLoadingAlternatives {
                                HStack {
                                    ProgressView()
                                    Text("Loading alternatives…")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 8)
                            } else if viewModel.alternativeItems.isEmpty {
                                Text("No alternatives found")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(viewModel.alternativeItems) { item in
                                            AlternativeProductCard(
                                                id: item.id,
                                                title: item.englishName,
                                                subtitle: item.koreanCategory,
                                                imageURL: URL(string: item.frontCoverURL ?? ""),
                                                isHalalKMF: item.isKmf,
                                                likes: item.favoriteCounter,
                                                onFavoriteTapped: {
                                                    print("Favorited \(item.id)")
                                                }
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)

                    // More Information
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        VStack(alignment: .leading, spacing: 0){
                            Text("More information:")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.primary)

                            Text("Korean Name:")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                            Text(viewModel.koreanNameWithPronunciation)
                                .font(.body)
                                .foregroundColor(.primary)


                            Text("English Translation:")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                            Text(viewModel.englishProductCategory)
                                .font(.body)
                                .foregroundColor(.primary)

                            Text("Company Name:")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                            Text(viewModel.koreanProducent)
                                .font(.body)
                                .foregroundColor(.primary)
                            Text("(\(viewModel.englishProducent))")
                                .font(.body)
                                .foregroundColor(.primary)

                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                BottomSheetContributeView(isPresented: $showSheet)
            }
            .task {
                await viewModel.scan(rawOCRText: rawOCRText)
            }
            .onChange(of: viewModel.isLoading) { isLoading in
                if isLoading {
                    startLoadingProgress()
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        loadingProgress = 1.0
                    }
                    stopLoadingTimer()
                }
            }
        }
    }
    
    // MARK: - Loading Progress Helpers
    private func startLoadingProgress() {
        loadingTimer?.invalidate()
        loadingProgress = 0.0
        loadingTimer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { timer in
            // Fill up to 90% while loading, then hold
            if viewModel.isLoading {
                let target = 0.90
                if loadingProgress < target {
                    loadingProgress = min(target, loadingProgress + 0.015)
                } else {
                    loadingProgress = target
                }
            } else {
                // Complete to 100% when finished
                loadingProgress = 1.0
                timer.invalidate()
                loadingTimer = nil
            }
        }
    }

    private func stopLoadingTimer() {
        loadingTimer?.invalidate()
        loadingTimer = nil
    }
}

#Preview {
    ScanResultView(onDismiss: {}, rawOCRText: "Sample OCR", fallbackImage: nil)
}
