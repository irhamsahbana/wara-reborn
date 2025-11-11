//
//  ResultView.swift
//  Wara
//
//  Created by Rizkydwiputra on 11/11/25.
//

import SwiftUI

struct ResultView: View {
    struct SimilarProduct: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let imageURL: URL?
        let isHalalKMF: Bool
        let likes: Int
    }

    private let similarProducts: [SimilarProduct] = [
        .init(title: "Strawberry Sticky Rice Cake",
              subtitle: "Rice Cake",
              imageURL: URL(string: "https://picsum.photos/200/101"),
              isHalalKMF: true,
              likes: 124),
        .init(title: "Mango Sticky Rice Cake",
              subtitle: "Rice Cake",
              imageURL: URL(string: "https://picsum.photos/200/102"),
              isHalalKMF: true,
              likes: 98),
        .init(title: "Melon Sticky Rice Cake",
              subtitle: "Rice Cake",
              imageURL: URL(string: "https://picsum.photos/200/103"),
              isHalalKMF: true,
              likes: 65),
        .init(title: "Blueberry Sticky Rice Cake",
              subtitle: "Rice Cake",
              imageURL: URL(string: "https://picsum.photos/200/104"),
              isHalalKMF: true,
              likes: 77)
    ]

    @Environment(\.dismiss) private var dismiss
    @State private var selectedIndex: Int? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header sederhana
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.08), radius: 3, x: 1, y: 1)
                                .shadow(color: Color.white.opacity(0.9), radius: 3, x: -1, y: -1)
                        )
                }

                Spacer()

                Text("Result")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.black)

                Spacer()

                Color.clear
                    .frame(width: 36, height: 36)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Kartu gambar produk (dari Assets)
                    CardView(backgroundColor: Color("chipBackground"), width: .infinity) {
                        VStack {
                            Image("PackagedFoodFront") // GANTI dengan nama aset Anda
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .padding(.vertical, 16)
                            
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    Text("Similar Product")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Array(similarProducts.enumerated()), id: \.offset) { index, item in
                            ZStack {
                                AlternativeProductCard(
                                    id: item.id.uuidString,
                                    title: item.title,
                                    subtitle: item.subtitle,
                                    imageURL: item.imageURL,
                                    isHalalKMF: item.isHalalKMF,
                                    likes: item.likes,
                                    onFavoriteTapped: { }
                                )
                                .overlay(
                                    Group {
                                        if selectedIndex == index {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(style: StrokeStyle(lineWidth: 4, dash: [6]))
                                                .foregroundColor(Color.purple)
                                                .padding(3)
                                        }
                                    }
                                )
                            }
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedIndex = selectedIndex == index ? nil : index
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Could not found the product?")
                            .font(.body.weight(.semibold))
                            .foregroundColor(.primary)
                        Text("Try capture back packaging")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    Button("Capture Back Packaging") {
                        // Navigate to capture flow
                    }
                    .buttonStyle(PrimaryButtonStyle(backgroundColor: Color("primaryblue")))
                    .padding(.horizontal, 16)
                    .padding(.top, 4)

                    Spacer(minLength: 16)
                }
                .padding(.bottom, 16)
            }
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    ResultView()
}
