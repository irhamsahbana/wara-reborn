//
//  SuspectedIngredientsView.swift
//  Wara
//
//  Created by Meow on 13/11/25
//

import SwiftUI

struct SuspectedIngredientsView: View {
    let ingredients: [ScanIngredientDTO]
    
    @Environment(\.dismiss) private var dismiss
    
    private var suspectedItems: [ScanIngredientDTO] {
        ingredients.filter { ["doubtful", "not_safe"].contains($0.category.lowercased()) }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Text("Suspected Ingredients")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.body.weight(.bold))
                            .foregroundColor(.black)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color.white)
                            )
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(suspectedItems.enumerated()), id: \.offset) { _, item in
                        CardView(backgroundColor: Color("chipBackground"), aligment: .leading, width: .infinity) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.englishName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                if !item.englishDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    Text(item.englishDescription)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Color("background").ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    let demo: [ScanIngredientDTO] = [
        ScanIngredientDTO(id: "1", rawText: "Whey", koreanName: "유청", englishName: "Whey", koreanPronunciation: "Yucheong", isFoundInDb: true, category: "doubtful", englishDescription: "Whey is a by-product of cheese production. The enzyme (Rennet) used to make the cheese has an unknown source (could be animal-derived)."),
        ScanIngredientDTO(id: "2", rawText: "Shortening", koreanName: "쇼트닝", englishName: "Shortening", koreanPronunciation: "Syoteuning", isFoundInDb: true, category: "doubtful", englishDescription: "Shortening is a solid fat, commonly found in bread, pastries, cakes, and biscuits. It can be made from vegetable oils or animal fats (e.g., beef or pork fat)."),
        ScanIngredientDTO(id: "3", rawText: "Sodium Caseinate", koreanName: "카제인나트륨", englishName: "Sodium Caseinate", koreanPronunciation: "Kajein Nateuryum", isFoundInDb: true, category: "not_safe", englishDescription: "Sodium Caseinate is protein from cow's milk. It’s commonly used as an emulsifier and thickener. Its status is syubhat because the separation process sometimes uses enzymes rennet or acids, the halal status of which must be confirmed.")
    ]
    return SuspectedIngredientsView(ingredients: demo)
}