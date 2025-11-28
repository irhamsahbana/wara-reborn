//
//  ScanResultBackView.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI
import UIKit

/// Main view for displaying back scan results with product details
struct ScanResultBackView: View {
    @ObservedObject var viewModel: ScanResultViewModel
    let fallbackImage: UIImage?
    let onDismiss: () -> Void
    
    @Binding var showAlternativeDetail: Bool
    
    var body: some View {
        ScrollView {
            // Product Info
            ProductInfoSection(
                isKMF: viewModel.isKMF,
                imageURLs: viewModel.imageURLs,
                fallbackImage: fallbackImage,
                englishName: viewModel.englishName,
                koreanName: viewModel.koreanName,
                koreanPronunciation: viewModel.koreanPronunciation,
                productType: viewModel.productType,
                statusMessage: viewModel.statusMessage
            )
            
            // Suspected Ingredients
            SuspectedIngredientsSection(
                productType: viewModel.productType,
                suspectedIngredients: viewModel.suspectedIngredientsEnglish,
                allIngredients: viewModel.data?.listedIngridients ?? []
            )
            
            // Ingredients
            IngredientsSection(
                listedIngredientsDisplay: viewModel.listedIngredientsDisplay,
                englishIngredients: viewModel.englishIngredients,
                notListedIngredients: viewModel.notListedIngredientsEnglish,
                isFacilityInformed: viewModel.isFacilityInformed,
                facilityInfo: viewModel.facilityInfo
            )
            
            // Certificate (KMF only)
            CertificateSection(
                isKMF: viewModel.isKMF,
                certificateNo: viewModel.kmfCertificateNo,
                certificateValid: viewModel.kmfCertificateValid
            )
            
            // Alternatives
            AlternativesSection(
                isKMF: viewModel.isKMF,
                productType: viewModel.productType,
                isLoading: viewModel.isLoadingAlternatives,
                items: viewModel.alternativeItems,
                onToggleFavorite: { itemId, isKmf in
                    viewModel.toggleFavorite(itemId: itemId, isKmf: isKmf)
                },
                onTapItem: { itemId, isKmf, completion in
                    viewModel.loadAlternativeDetail(id: itemId, isKmf: isKmf) { result in
                        switch result {
                        case .success:
                            showAlternativeDetail = true
                            completion(true)
                        case .failure:
                            completion(false)
                        }
                    }
                }
            )
            
            // More Information
            MoreInformationSection(
                koreanNameWithPronunciation: viewModel.koreanNameWithPronunciation,
                englishProductCategory: viewModel.englishProductCategory,
                koreanProducent: viewModel.koreanProducent,
                englishProducent: viewModel.englishProducent
            )
        }
    }
}

#Preview {
    ScanResultBackView(
        viewModel: {
            let vm = ScanResultViewModel()
            // Mock data for preview
            return vm
        }(),
        fallbackImage: nil,
        onDismiss: {},
        showAlternativeDetail: .constant(false)
    )
}
