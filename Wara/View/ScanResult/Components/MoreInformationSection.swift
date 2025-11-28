//
//  MoreInformationSection.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI

/// Section displaying additional product information (name, category, company)
struct MoreInformationSection: View {
    let koreanNameWithPronunciation: String
    let englishName: String
    let englishProductCategory: String
    let koreanProducent: String
    let englishProducent: String
    
    var body: some View {
        CardView(backgroundColor: Color("waraChipBackground"), aligment: .leading, width: .infinity) {
            VStack(alignment: .leading, spacing: 0) {
                Text("More information:")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)

                Text("Korean Name:")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.top, 8)
                Text(koreanNameWithPronunciation)
                    .font(.body)
                    .foregroundColor(.primary)

                Text("English Translation:")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.top, 8)
                Text(englishName)
                    .font(.body)
                    .foregroundColor(.primary)

                Text("Category:")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.top, 8)
                Text(englishProductCategory)
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
    }
}

#Preview {
    ScrollView {
        MoreInformationSection(
            koreanNameWithPronunciation: "딸기 찹쌀떡 (ttal-gi chap-ssal-tteok)",
            englishName: "Strawberry Sticky Rice Cake",
            englishProductCategory: "Rice Cake",
            koreanProducent: "누들트리",
            englishProducent: "Noodle Tree"
        )
    }
    .background(Color("waraBackground"))
}
