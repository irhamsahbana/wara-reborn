//
//  FoodDetailView.swift
//  Wara
//
//  Created by Meow on 29/10/25.
//

import SwiftUI

struct FoodDetailView: View {
    let id: String
    let title: String
    let description: String
    let iconURL: URL?
    let headerBackgroundColor: Color

    init(
        id: String,
        title: String,
        description: String? = nil,
        iconURL: URL? = nil,
        headerBackgroundColor: Color? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description ?? "Taste what locals love! Curated Korean food you can enjoy with confidence."
        self.iconURL = iconURL
        self.headerBackgroundColor = headerBackgroundColor ?? Color("waraSliderYellow")
    }
    
    @State private var searchText = ""
    let columns = [
           GridItem(.flexible(), spacing: 12),
           GridItem(.flexible(), spacing: 12)
        ]
    
    var body: some View {
        VStack{
            FoodDetailHeader(
                id: id,
                title: title,
                description: description,
                iconURL: iconURL,
                backgroundColor: headerBackgroundColor
            )
            .frame(maxWidth: .infinity)
            
            SearchBar(text: $searchText)
                .padding(.horizontal)
                .padding(.top, 55)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ChipButton(label: "All", isSelected: true) {
                        
                    }
                    
                    ChipButton(label: "Halal KMF", isSelected: false) {
                        
                    }
                    
                    ChipButton(label: "Safe to Eat", isSelected: false) {
                        
                    }
                    
                    ChipButton(label: "Popular", isSelected: false) {
                        
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 10)
            
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
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .background(Color("waraBackground"))
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FoodDetailView(id: "", title: "Food Souvenirs")
}
