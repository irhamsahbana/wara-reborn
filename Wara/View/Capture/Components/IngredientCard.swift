//
//  IngredientCard.swift
//  Wara
//
//  Created by Immanuel Sitepu on 25/06/25.
//

import SwiftUI

struct IngredientCard: View {
    let ingredient: Ingredient
    
    private var categoryColor: Color {
        switch ingredient.category {
        case .aman: return .green
        case .raguRagu: return .orange
        case .tidakAman: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header Kartu: Nama & Kategori
            HStack {
                Text(ingredient.koreanName)
                    .font(.headline)
                    .fontWeight(.bold)
                
                if !ingredient.pronunciation.isEmpty {
                    Text(ingredient.pronunciation)
                        .font(.subheadline)
                        .italic()
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                Text(ingredient.category.rawValue.capitalized)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(categoryColor)
                    .cornerRadius(8)

            }
            

            
            Text(ingredient.englishName)
                .font(.body)
                .fontWeight(.medium)
            
            // Deskripsi
            if !ingredient.descriptionText.isEmpty {
                Divider()
                Text(ingredient.descriptionText)
                    .font(.body)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}


#Preview {
    // Membuat beberapa contoh data untuk ditampilkan di preview
    let amanIngredient = Ingredient(
        koreanName: "소금",
        pronunciation: "Sogeum",
        englishName: "Salt",
        descriptionText: "Garam mineral yang diekstrak dari air laut atau tambang. Dianggap halal untuk dikonsumsi.",
        category: .aman
    )
    
    let raguRaguIngredient = Ingredient(
        koreanName: "젤라틴",
        pronunciation: "Jellatin",
        englishName: "Gelatin",
        descriptionText: "Bisa berasal dari babi, sapi, atau ikan. Perlu dipastikan sumbernya. Tanpa sertifikasi, statusnya syubhat.",
        category: .raguRagu
    )
    
    let tidakAmanIngredient = Ingredient(
        koreanName: "돼지고기",
        pronunciation: "Dwaeji-gogi",
        englishName: "Pork",
        descriptionText: "Daging babi yang diharamkan dalam Islam.",
        category: .tidakAman
    )
    
    // Menampilkan semua variasi kartu dalam sebuah ScrollView
    return ScrollView {
        VStack(spacing: 20) {
            Text("Contoh Kartu Bahan").font(.largeTitle).bold()
            
            IngredientCard(ingredient: tidakAmanIngredient)
            IngredientCard(ingredient: raguRaguIngredient)
            IngredientCard(ingredient: amanIngredient)
        }
        .padding()
    }
}
