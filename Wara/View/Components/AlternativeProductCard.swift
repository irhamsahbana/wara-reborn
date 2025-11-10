//
//  AlternativeProductCard.swift
//  Wara
//
//  Created by Meow on 10/11/25
//

import SwiftUI

struct AlternativeProductCard: View {
    let id: String?
    let title: String
    let subtitle: String
    let imageURL: URL?
    let isHalalKMF: Bool
    let likes: Int
    let onFavoriteTapped: (() -> Void)?
    let width: CGFloat = 160
    let height: CGFloat = 220

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                CachedRemoteImageView(id: id, url: imageURL, contentMode: .fit, cornerRadius: 12)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.all, 8)

                Button(action: { onFavoriteTapped?() }) {
                    Image(systemName: "heart")
                        .foregroundColor(.black)
                        .padding(5)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 1)
                }
                .padding(10)
                .padding(.top, 2)

                if isHalalKMF {
                    Image("halal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 35)
                        .padding(.top, 67)
                        .padding(.trailing, 10)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if isHalalKMF {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color("green2"))
                            .font(.caption)
                        Text("Halal KMF")
                            .font(.caption)
                            .foregroundColor(Color("green2"))
                    }
                }

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
        .background(Color("chipBackground"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("green2").opacity(0.4), lineWidth: 6)
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .frame(width: width)
        .frame(height: height)
        .clipped()
    }
}

#Preview {
    AlternativeProductCard(
        id: "demo",
        title: "FortiFour Shake Cookies and Cream Flavor",
        subtitle: "기타가공품",
        imageURL: URL(string: "https://picsum.photos/200/100"),
        isHalalKMF: true,
        likes: 384,
        onFavoriteTapped: {}
    )
}