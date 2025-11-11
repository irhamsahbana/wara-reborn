//
//  ScannedProductView.swift
//  Wara
//
//  Created by Meow on 11/11/25
//

import SwiftUI

struct ScannedProductView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query: String = ""
    @State private var products: [ScannedProductView.Product] = ScannedProductView.SampleData.products

    private var filteredProducts: [ScannedProductView.Product] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return products }
        return products.filter { product in
            product.name.localizedCaseInsensitiveContains(trimmed) ||
            product.category.localizedCaseInsensitiveContains(trimmed)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                searchBar

                if filteredProducts.isEmpty {
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    emptyState
                } else {
                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                        spacing: 12
                    ) {
                        ForEach(filteredProducts) { product in
                            ScannedProductView.ProductCard(product: product)
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
            .padding(.top, 8)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .background(Color("background").ignoresSafeArea())
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "chevron.up")
                .foregroundColor(.primary)
                .font(.headline.weight(.medium))
            HStack(spacing: 8) {
                Image(systemName: "camera.fill")
                    .foregroundColor(.primary)
                Text("Back To Scan")
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 16)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            dismiss()
        }
        .gesture(
            DragGesture(minimumDistance: 10)
                .onEnded { value in
                    if value.translation.height > 30 {
                        dismiss()
                    }
                }
        )
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(
                "Search your scanned product",
                text: $query,
                prompt: Text("Search your scanned product").foregroundColor(.gray)
            )
                .textFieldStyle(.plain)
                .font(.body.weight(.medium))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
        )
        .padding(.horizontal, 16)
    }
}

private extension ScannedProductView {
    var emptyState: some View {
        VStack(spacing: 16) {
            Image("girl")
                .resizable()
                .scaledToFit()
                .frame(height: 160)

            Text("Your saved products will appear here.\nTap on the heart icon next to the products image to save")
                .font(.body.weight(.medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }
}

// MARK: - Nested Types & Components

extension ScannedProductView {
    enum ProductStatus {
        case safe
        case doubtful
        case halal

        var borderColor: Color {
            switch self {
            case .safe, .halal: return Color.green
            case .doubtful: return Color.yellow
            }
        }

        var labelText: String {
            switch self {
            case .safe: return "Safe"
            case .doubtful: return "Doubtful"
            case .halal: return "Halal KMF"
            }
        }

        var labelIcon: String {
            switch self {
            case .safe: return "checkmark.circle.fill"
            case .doubtful: return "exclamationmark.triangle.fill"
            case .halal: return "leaf.fill"
            }
        }

        var labelColor: Color {
            switch self {
            case .safe, .halal: return Color.green
            case .doubtful: return Color.orange
            }
        }
    }

    struct Product: Identifiable {
        let id = UUID()
        let name: String
        let category: String
        let status: ProductStatus
        let imageName: String?
    }

    struct ProductCard: View {
        let product: Product

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(height: 90)
                        .overlay(
                            Group {
                                if let name = product.imageName, !name.isEmpty {
                                    Image(name)
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.secondary)
                                        .padding(20)
                                }
                            }
                        )
                }

                Text(product.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(product.category)
                    .font(.caption)
                    .foregroundColor(.primary)
                
                Spacer(minLength: 0)

                HStack(spacing: 6) {
                    Image(systemName: product.status.labelIcon)
                        .foregroundColor(product.status.labelColor)
                    Text(product.status.labelText)
                        .font(.caption)
                        .foregroundColor(product.status.labelColor)
                    Spacer()
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(product.status.borderColor, lineWidth: 2)
            )
        }
    }

    enum SampleData {
        static let products: [Product] = [
//            Product(name: "Korean Snack", category: "Snack", status: .safe, imageName: nil),
//            Product(name: "Strawberry Sticky Rice Cake", category: "Rice Cake", status: .halal, imageName: nil),
//            Product(name: "Korean Snack", category: "Snack", status: .doubtful, imageName: nil),
//            Product(name: "Korean Snack", category: "Snack", status: .doubtful, imageName: nil),
//            Product(name: "Korean Snack", category: "Snack", status: .safe, imageName: nil),
//            Product(name: "Strawberry Sticky Rice Cake", category: "Rice Cake", status: .halal,  imageName: nil),
//            Product(name: "Korean Snack", category: "Snack", status: .doubtful,  imageName: nil),
//            Product(name: "Korean Snack", category: "Snack", status: .doubtful,  imageName: nil)
        ]
    }
}

#Preview {
    NavigationStack {
        ScannedProductView()
    }
}
