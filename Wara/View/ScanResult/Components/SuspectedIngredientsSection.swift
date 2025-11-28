//
//  SuspectedIngredientsSection.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI

/// Section showing suspected haram ingredients with link to detailed view
struct SuspectedIngredientsSection: View {
    let productType: ProductType
    let suspectedIngredients: [String]
    let allIngredients: [ScanIngredientDTO]
    
    var body: some View {
        if productType == .DOUBTFULL || productType == .NON_HALAL {
            CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Suspected Ingredients:")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)

                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(suspectedIngredients.joined(separator: ", "))
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .truncationMode(.tail)

                        if !suspectedIngredients.isEmpty {
                            NavigationLink(
                                destination: SuspectedIngredientsView(
                                    ingredients: allIngredients
                                )
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
    }
}

#Preview {
    ScrollView {
        SuspectedIngredientsSection(
            productType: .DOUBTFULL,
            suspectedIngredients: ["Gelatin", "Emulsifier E471"],
            allIngredients: [
                ScanIngredientDTO(
                    id: "1",
                    rawText: "젤라틴",
                    koreanName: "젤라틴",
                    englishName: "Gelatin",
                    koreanPronunciation: "jel-la-tin",
                    isFoundInDb: true,
                    category: "doubtful",
                    englishDescription: "May contain animal-derived ingredients"
                )
            ]
        )
    }
    .background(Color("background"))
}
