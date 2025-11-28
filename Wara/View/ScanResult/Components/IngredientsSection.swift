//
//  IngredientsSection.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI

/// Section displaying listed and unlisted ingredients with facility information
struct IngredientsSection: View {
    let listedIngredientsDisplay: [ScanResultViewModel.IngredientDisplayItem]
    let englishIngredients: String
    let notListedIngredients: [String]
    let isFacilityInformed: Bool
    let facilityInfo: String
    
    var body: some View {
        CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity) {
            VStack(alignment: .leading, spacing: 8) {
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

                if !notListedIngredients.isEmpty {
                    Text("Unknown Ingredients:")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)

                    Text(notListedIngredients.joined(separator: ", "))
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
    }
    
    private func coloredIngredientText(_ items: [ScanResultViewModel.IngredientDisplayItem]) -> Text {
        var result = Text("")
        for (index, item) in items.enumerated() {
            let color = item.category == "not_safe" ? Color.red : Color.primary
            result = result + Text(item.name).foregroundColor(color)
            if index < items.count - 1 {
                result = result + Text(", ").foregroundColor(.secondary)
            }
        }
        return result
    }
}

#Preview {
    ScrollView {
        IngredientsSection(
            listedIngredientsDisplay: [
                ScanResultViewModel.IngredientDisplayItem(name: "Wheat Flour", category: "safe"),
                ScanResultViewModel.IngredientDisplayItem(name: "Sugar", category: "safe"),
                ScanResultViewModel.IngredientDisplayItem(name: "Gelatin", category: "not_safe")
            ],
            englishIngredients: "Wheat Flour, Sugar, Gelatin, Salt",
            notListedIngredients: ["Modified Starch", "Natural Flavoring"],
            isFacilityInformed: true,
            facilityInfo: "This product is manufactured in a facility that also processes milk, eggs, and soybeans"
        )
    }
    .background(Color("background"))
}
