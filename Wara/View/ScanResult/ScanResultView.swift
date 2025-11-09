//
//  ResultView.swift
//  Wara
//
//  Created by Meow on 30/10/25.
//

import SwiftUI

struct ScanResultView: View {
    let onDismiss: () -> Void
    let rawOCRText: String

    @StateObject private var viewModel = ScanResultViewModel()
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                CustomAppBar(
                    onBack: { onDismiss() },
                    onFavorite: { print("Favorite tapped") }
                )
                
                if viewModel.isLoading && viewModel.data == nil {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Scanning product…")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
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
                                    imageURLs: viewModel.imageURLs
                                )

                                Text(viewModel.englishName)
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(.primary)
                                    .padding(.top, 10)

                                Text(viewModel.koreanNameWithPronunciation)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                ResultInfoCard(productType: viewModel.productType)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                    
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        if(viewModel.productType == ProductType.HALAL){
                            VStack(alignment: .leading, spacing: 12){
                                Text("Certificate No :")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.black)
                                
                                Text("KMFHC22-0231")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text("Certificate Valid :")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.black)
                                
                                Text("2022-10-18 ~ 2025-10-17")
                                    .font(.caption)
                                    .foregroundColor(.gray)
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
                        
                        if(viewModel.productType == ProductType.DOUBTFULL || viewModel.productType == ProductType.NON_HALAL){
                            VStack(alignment: .leading, spacing: 12){
                                Text("Suspected Ingredient :")
                                    .font(.subheadline.weight(.semibold))
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
                        VStack(alignment: .leading, spacing: 12){
                            Text("Ingredient :")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            Text(viewModel.englishIngredients)
                                .font(.caption)
                                .foregroundColor(.primary)

                            if !viewModel.listedIngredientsEnglish.isEmpty {
                                Text("Listed Ingredients :")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.primary)
                                    .padding(.top, 8)

                                Text(viewModel.listedIngredientsEnglish.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }

                            if !viewModel.notListedIngredientsEnglish.isEmpty {
                                Text("Not Listed Ingredients :")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.primary)
                                    .padding(.top, 8)

                                Text(viewModel.notListedIngredientsEnglish.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }

                            if viewModel.isFacilityInformed {
                                Text("Manufactured with same Facility :")
                                    .font(.body.weight(.semibold))
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
                    
                    // More Information
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        VStack(alignment: .leading, spacing: 0){
                            Text("More information :")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Korean Name :")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                            Text(viewModel.koreanNameWithPronunciation)
                                .font(.body)
                                .foregroundColor(.primary)
                                
                            
                            Text("English Translation :")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                            Text(viewModel.englishProductCategory)
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Text("Company Name :")
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
                    
                    // Alternative Product
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        VStack(alignment: .leading){
                            Text("Alternative Product :")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    FoodCard(
                                        title: "Choco Sticks",
                                        subtitle: "Cho-kho seu-tik",
                                        label: "Halal KMF",
                                        likes: 1020,
                                        isLike: true,
                                        isHalalKMF: true,
                                        width: nil,
                                        onFavoriteTapped: {
                                            print("Favorited!")
                                        }
                                    )
                                    
                                    FoodCard(
                                        title: "Choco Sticks",
                                        subtitle: "Cho-kho seu-tik",
                                        label: "Halal KMF",
                                        likes: 1020,
                                        isLike: true,
                                        isHalalKMF: true,
                                        width: nil,
                                        onFavoriteTapped: {
                                            print("Favorited!")
                                        }
                                    )
                                   
                                    FoodCard(
                                        title: "Choco Sticks",
                                        subtitle: "Cho-kho seu-tik",
                                        label: "Halal KMF",
                                        likes: 1020,
                                        isLike: true,
                                        isHalalKMF: true,
                                        width: nil,
                                        onFavoriteTapped: {
                                            print("Favorited!")
                                        }
                                    )
                                }
                            }
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
        }
    }
}

#Preview {
    ScanResultView(onDismiss: {}, rawOCRText: "Sample OCR")
}
