//
//  ScannedProductView.swift
//  Wara
//
//  Created by Meow on 29/10/25.
//

import SwiftUI

struct ScannedProductGridView: View {
    let columns = [
           GridItem(.flexible(), spacing: 12),
           GridItem(.flexible(), spacing: 12)
       ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns, spacing: 12) {
                FoodCard(
                    title: "Choco Sticks",
                    subtitle: "Cho-kho seu-tik",
                    label: "Halal KMF",
                    likes: 1020,
                    isLike: true,
                    isHalalKMF: true,
                    width: .infinity,
                    onFavoriteTapped: {
                        print("Favorited!")
                    }
                )
                
                FoodCard(
                    title: "Choco Sticks",
                    subtitle: "Cho-kho seu-tik",
                    label: "Halal KMF",
                    likes: 1020,
                    isLike: true,
                    isHalalKMF: true,
                    width: .infinity,
                    onFavoriteTapped: {
                        print("Favorited!")
                    }
                )
                
                FoodCard(
                    title: "Choco Sticks",
                    subtitle: "Cho-kho seu-tik",
                    label: "Halal KMF",
                    likes: 1020,
                    isLike: true,
                    isHalalKMF: true,
                    width: .infinity,
                    onFavoriteTapped: {
                        print("Favorited!")
                    }
                )
                
                FoodCard(
                    title: "Choco Sticks",
                    subtitle: "Cho-kho seu-tik",
                    label: "Halal KMF",
                    likes: 1020,
                    isLike: true,
                    isHalalKMF: true,
                    width: .infinity,
                    onFavoriteTapped: {
                        print("Favorited!")
                    }
                )
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScannedProductGridView()
}
