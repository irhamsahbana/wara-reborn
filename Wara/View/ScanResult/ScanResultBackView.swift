//
//  ScanResultBackView.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI
import UIKit

/// Displays detailed analysis of back label scan results.
///
/// **Layout Structure:**
/// 1. Product Info: Name, type, KMF status, images
/// 2. Suspected Ingredients: Red-flagged ingredients based on category
/// 3. All Ingredients: Complete ingredient list with color coding
/// 4. Certificate: KMF certificate details (if applicable)
/// 5. Alternatives: Similar halal products
/// 6. More Information: Producer details and translations
///
/// **Color Coding:**
/// - Red: Haram/suspected ingredients
/// - Black: Safe ingredients
///
/// **Data Source:**
/// All data comes from `ScanResultViewModel` which handles API calls
/// and ingredient analysis.
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
                englishName: viewModel.englishName,
                englishProductCategory: viewModel.englishProductCategory,
                koreanProducent: viewModel.koreanProducent,
                englishProducent: viewModel.englishProducent
            )

            ReportIssueSection(
                toEmail: "business.irham@gmail.com",
                subject: "Report/Request Update",
                englishName: viewModel.englishName,
                koreanName: viewModel.koreanName,
                productId: viewModel.scannedProductId ?? "",
                isKmf: viewModel.isKMF
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
