//
//  IngredientListView.swift
//  Wara
//
//  Created by Immanuel Sitepu on 25/06/25.
//

import SwiftUI

struct IngredientListView: View {
    let ingredients: [Ingredient]
    let category: IngredientCategory

    var body: some View {
        List {
            ForEach(ingredients, id: \.koreanName) { ingredient in
                IngredientCard(ingredient: ingredient)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationTitle(category.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
}
