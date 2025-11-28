//
//  CategoryGridView.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//
import SwiftUI

struct CategoryGridView: View {
    @StateObject private var viewModel = CategoryViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16, alignment: .top),
        GridItem(.flexible(), spacing: 16, alignment: .top),
        GridItem(.flexible(), spacing: 16, alignment: .top),
        GridItem(.flexible(), spacing: 16, alignment: .top)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                    Text("Memuat kategori...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            } else if let error = viewModel.errorMessage {
                HStack {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                    Spacer()
                    Button("Coba Lagi") {
                        viewModel.loadCategories()
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal)
            }
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(viewModel.categories) { category in
                    NavigationLink{
                        FoodDetailView(
                            id: category.id.uuidString,
                            title: category.name,
                            description: category.description,
                            iconURL: category.iconURL,
                            headerBackgroundColor: Color("waraSliderGreen")
                        )
                    } label: {
                        VStack(alignment: .center, spacing: 6) {
                            ZStack {
                                if let url = category.iconURL {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 36, height: 36)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 72, height: 72)
                                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 36, height: 36)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(16)
                            
                            Text(category.name)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.85)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
        }
        .onAppear { viewModel.loadCategories() }
    }
}

#Preview {
    CategoryGridView()
}
