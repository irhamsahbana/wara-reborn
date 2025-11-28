//
//  FoodListView.swift
//  Wara
//
//  Created by Meow on 20/10/25.
//

import SwiftUI

/// Main food/home tab showing curated content and recommendations.
///
/// **Sections:**
/// 1. Slider: Featured Korean food items
/// 2. Scan CTA: Call-to-action card encouraging users to scan products
/// 3. Category Grid: Browse products by category
/// 4. Random Favorites: Discover popular halal products
///
/// **Layout:**
/// All content is scrollable vertically with hidden scroll indicators.
/// The scan card is positioned with negative top padding (-50) to overlap
/// with the slider for visual depth.
struct FoodListView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 0){
                SliderView()
                
                HStack{
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Korean Food\nScanner")
                            .font(.body.bold())
                            .foregroundColor(.primary)
                           

                        Text("See what your fellow Chingu recommend")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    Image("scan")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color("cardBackground"))
                .cornerRadius(12)
                .padding(.horizontal, 16)
                .padding(.top, -50)
               
                CategoryGridView()
                
                RandomFavoriteView()
                
                Spacer()
            }
            .background(Color("background"))
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    FoodListView()
}
