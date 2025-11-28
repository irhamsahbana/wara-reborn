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
    let isFavorited: Bool
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
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? .red : .black)
                        .padding(5)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 1)
                }
                .padding(10)
                .padding(.top, 2)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .truncationMode(.tail)

                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer(minLength: 0)

                if isHalalKMF {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.waraHalal)
                            .font(.caption)
                        Text("Halal KMF")
                            .font(.caption)
                            .foregroundColor(Color.waraHalal)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.waraChipBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.waraHalal.opacity(0.4), lineWidth: 6)
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .frame(width: width, height: height)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    AlternativeProductCard(
        id: "demo",
        title: "FortiFour Shake Cookies and Cream Flavor",
        subtitle: "기타가공품",
        imageURL: URL(string: "https://picsum.photos/200/100"),
        isHalalKMF: true,
        isFavorited: false,
        onFavoriteTapped: {}
    )
}