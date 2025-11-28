//
//  FoodDetailHeader.swift
//  Wara
//
//  Created by Meow on 29/10/25.
//

import SwiftUI

struct FoodDetailHeader: View {
    let id: String
    let title: String
    let description: String
    let iconURL: URL?
    let backgroundColor: Color
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            ZStack(alignment: .topLeading) {
                LinearGradient(
                    gradient: Gradient(colors: [
                        backgroundColor,
                        Color.waraSurface
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .top)

                VStack(alignment: .leading, spacing: 8) {
                    HStack{
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .padding(19)
                                .background(Color.white.opacity(0.3))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.trailing, 40)
                        
                        
                        Spacer()
                    }
                    
                    HStack{
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        Group {
                            if let url = iconURL {
                                CachedRemoteImageView(id: id, url: url, contentMode: .fit, cornerRadius: 12)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(width: 90, height: 90)
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 100)
            }
            .frame(height: 180)
        }
}

#Preview {
    FoodDetailHeader(
        id: "",
        title: "Food Souvenirs",
        description: "Taste what locals love! Curated Korean food you can enjoy with confidence.",
        iconURL: nil,
        backgroundColor: Color.waraSliderYellow
    )
}
