//
//  FoodCard.swift
//  Wara
//
//  Created by Meow on 28/10/25.
//

import SwiftUI

struct FoodCard: View {
    let title: String
    let subtitle: String
    let label: String
    let likes: Int
    let isLike: Bool
    let isHalalKMF: Bool
    let width: CGFloat?
    let height: CGFloat? = nil
    let onFavoriteTapped: (() -> Void)?
    
    var body: some View {
        // Safely resolve width: treat non-finite/negative as default, and
        // support .infinity via maxWidth instead of fixed width.
        let isInfiniteWidth = width?.isInfinite == true
        let resolvedWidth: CGFloat = {
            guard let w = width else { return 160 }
            if w.isNaN || !w.isFinite || w <= 0 { return 160 }
            return w
        }()
        let resolvedHeight: CGFloat = {
            guard let h = height else { return 220 }
            if h.isNaN || !h.isFinite || h <= 0 { return 220 }
            return h
        }()
        
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                // Product image
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        Image("slider3")
                            .resizable()
                            .scaledToFit()
                            .padding(12)
                    )
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.all, 8)
                
                // Favorite button
                Button(action: {
                    onFavoriteTapped?()
                }) {
                    if(isLike){
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .padding(5)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }else{
                        Image(systemName: "heart")
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }
                }
                .padding(10)
                .padding(.top, 2)
                
                
                    
            }
            
            // Product information
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Label
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("waraHalal"))
                        .font(.caption)
                    Text(label)
                        .font(.caption)
                        .foregroundColor(Color("waraHalal"))
                }
                
                // Likes count
                HStack(spacing: 4) {
                    Image(systemName: "heart")
                        .foregroundColor(.primary)
                        .font(.caption)
                    Text("\(likes)")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color("waraChipBackground"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("waraHalal").opacity(0.4), lineWidth: 6)
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .frame(maxWidth: isInfiniteWidth ? .infinity : nil)
        .frame(width: isInfiniteWidth ? nil : resolvedWidth)
        .frame(height: resolvedHeight)
        .clipped()

    }
}


#Preview {
    FoodCard(
        title: "Choco Sticks",
        subtitle: "Cho-kho seu-tik",
        label: "Halal KMF",
        likes: 1020,
        isLike: true,
        isHalalKMF: true,
        width: nil,
        onFavoriteTapped: {
            print("Favorited!")
        }
    )
}
