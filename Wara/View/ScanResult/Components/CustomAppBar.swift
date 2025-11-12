//
//  CustomAppBarView.swift
//  Wara
//
//  Created by Meow on 31/10/25.
//

import SwiftUI

struct CustomAppBar: View {
    var title: String = "Details"
    var onBack: (() -> Void)?
    var onFavorite: (() -> Void)?
    var isFavoriteEnabled: Bool = true
    
    var body: some View {
        HStack {
            // Left Button (Back)
            Button(action: {
                onBack?()
            }) {
                Image(systemName: "chevron.left")
                    .font(.body.weight(.bold))
                    .foregroundColor(.black)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.white)
                    )
            }
            
            Spacer()
            
            // Title
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            if isFavoriteEnabled {
                Button(action: {
                    onFavorite?()
                }) {
                    Image(systemName: "heart")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white)
                        )
                }
            } else {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color("surfaceCustomAppBar"))
    }
}

#Preview {
    CustomAppBar(
        onBack: { print("Back tapped") },
        onFavorite: { print("Favorite tapped") }
    )
    .padding()
}
