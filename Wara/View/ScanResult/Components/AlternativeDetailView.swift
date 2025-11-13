import SwiftUI
import UIKit

struct AlternativeDetailView: View {
    let detail: AlternativeProductDetailDTO
    let fallbackImage: UIImage?

    private var productType: ProductType {
        switch detail.status?.lowercased() {
        case "kmf_certified": return .HALAL
        case "no_haram": return .SAFE_TO_CONSUME
        case "doubtful": return .DOUBTFULL
        case "haram": return .NON_HALAL
        default: return .SAFE_TO_CONSUME
        }
    }

    private var isKMF: Bool { detail.isKmf ?? false }

    private var imageURLs: [URL] {
        [detail.frontCoverURL, detail.backCoverURL]
            .compactMap { $0 }
            .compactMap { URL(string: $0) }
    }

    private var englishName: String { detail.englishName ?? "" }
    private var koreanName: String { detail.koreanName ?? "" }
    private var koreanPronunciation: String { detail.koreanPronunciation ?? "" }
    private var englishIngredients: String { detail.englishIngredients ?? "" }
    private var facilityInfo: String { detail.facility?.englishDescription ?? detail.englishFacilityInfo ?? "" }
    private var isFacilityInformed: Bool { detail.facility?.isInformed ?? false }
    private var statusMessage: String { detail.statusMessage ?? "" }

    private struct IngredientDisplayItem {
        let name: String
        let category: String
    }

    private var listedIngredientsDisplay: [IngredientDisplayItem] {
        (detail.listedIngridients ?? [])
            .map { IngredientDisplayItem(name: $0.englishName, category: $0.category.lowercased()) }
    }

    private var suspectedIngredientsEnglish: [String] {
        (detail.listedIngridients ?? [])
            .filter { ["doubtful", "not_safe"].contains($0.category.lowercased()) }
            .map { $0.englishName }
    }

    private var notListedIngredientsEnglish: [String] {
        (detail.notListedIngridients ?? [])
            .map { $0.englishName }
    }

    private var englishProducent: String { detail.englishProducent ?? "" }
    private var koreanProducent: String { detail.koreanProducent ?? "" }
    private var kmfCertificateNo: String { detail.certificateNo ?? "" }
    private var kmfCertificateValid: String { detail.certificateValid ?? "" }

    private func coloredIngredientText(_ items: [IngredientDisplayItem]) -> Text {
        var result = Text("")
        for (index, item) in items.enumerated() {
            let color: Color = item.category == "not_safe" ? .red : .primary
            result = result + Text(item.name).foregroundColor(color)
            if index < items.count - 1 {
                result = result + Text(", ").foregroundColor(.secondary)
            }
        }
        return result
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
                .padding(.top, 24)
                .padding(.horizontal, 16)

                // Suspected ingredients (if applicable)
                if productType == .DOUBTFULL || productType == .NON_HALAL {
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        VStack(alignment: .leading, spacing: 12){
                            Text("Suspected Ingredients:")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.primary)

                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                Text(suspectedIngredientsEnglish.joined(separator: ", "))
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .truncationMode(.tail)

                                if !(detail.listedIngridients ?? []).isEmpty {
                                    NavigationLink(
                                        destination: SuspectedIngredientsView(ingredients: detail.listedIngridients ?? [])
                                    ) {
                                        Text("Learn More")
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundColor(Color("primaryblue"))
                                    }
                                    .padding(.leading, 6)
                                }
                            }
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                }

                // Ingredients + Unknown + Facility
                CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                    VStack(alignment: .leading, spacing: 8){
                        Text("Ingredients:")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.primary)

                        if !listedIngredientsDisplay.isEmpty {
                            coloredIngredientText(listedIngredientsDisplay)
                                .font(.caption)
                        } else {
                            if !englishIngredients.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text(englishIngredients)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }

                        if !notListedIngredientsEnglish.isEmpty {
                            Text("Unknown Ingredients:")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.primary)

                            Text(notListedIngredientsEnglish.joined(separator: ", "))
                                .font(.caption)
                                .foregroundColor(.primary)
                        }

                        if isFacilityInformed {
                            Text("Manufactured with same Facility :")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.primary)
                                .padding(.top, 8)

                            Text(facilityInfo)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)

                // Certificate and share section
                CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                    if isKMF {
                        VStack(alignment: .leading, spacing: 12){
                            Text("Certificate No:")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.primary)

                            Text(kmfCertificateNo)
                                .font(.caption)
                                .foregroundColor(.primary)

                            Text("Certificate Valid:")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.primary)

                            Text(kmfCertificateValid)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }

                    if productType == .SAFE_TO_CONSUME {
                        VStack(alignment: .center, spacing: 12){
                            Text("Looks like this product’s new to us! ")
                                .font(.body.weight(.semibold))
                                .foregroundColor(.primary)

                            Text("Sharing this product to Wara, Your contribution help others find safer food choices that align with halal principles.")
                                .font(.body)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)

                // More information at the end
                CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                    VStack(alignment: .leading){
                        Text("More information:")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.primary)

                        Text("Korean Name:")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                        Text(koreanName)
                            .font(.body)
                            .foregroundColor(.primary)

                        Text("English Translation:")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                        Text(englishName)
                            .font(.body)
                            .foregroundColor(.primary)

                        Text("Company Name:")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                        Text(koreanProducent)
                            .font(.body)
                            .foregroundColor(.primary)
                        Text("(\(englishProducent))")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)

                if productType == .DOUBTFULL || productType == .NON_HALAL {
                    CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity){
                        VStack(alignment: .leading, spacing: 12){
                            Text("Suspected Ingredients:")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.primary)

                            HStack(alignment: .firstTextBaseline, spacing: 6) {
                                Text(suspectedIngredientsEnglish.joined(separator: ", "))
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .truncationMode(.tail)

                                if !(detail.listedIngridients ?? []).isEmpty {
                                    NavigationLink(
                                        destination: SuspectedIngredientsView(ingredients: detail.listedIngridients ?? [])
                                    ) {
                                        Text("Learn More")
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundColor(Color("primaryblue"))
                                    }
                                    .padding(.leading, 6)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }

            }
            .padding(.bottom, 8)
        }
    }
}