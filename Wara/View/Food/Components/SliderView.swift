//
//  SliderView.swift
//  Wara
//
//  Created by Meow on 28/10/25.
//

import SwiftUI

struct SliderView: View {
    @StateObject private var viewModel = RecommendationViewModel()
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentIndex) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: 180)
                        .tag(0)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: 180)
                        .tag(0)
                } else if viewModel.items.isEmpty {
                    Text("No recommendations available yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: 180)
                        .background(Color.waraSliderYellow)
                        .tag(0)
                } else {
                    ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                        NavigationLink {
                            FoodDetailView(
                                id: item.id.uuidString,
                                title: item.name,
                                description: item.description,
                                iconURL: item.iconURL,
                                headerBackgroundColor: Color.waraSliderYellow
                            )
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                }
                                Spacer()
                                if let url = item.iconURL {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .frame(width: 90, height: 90)
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 90, height: 90)
                                }
                            }
                            .padding(.top, 50)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, maxHeight: 180)
                            .background(Color.waraSliderYellow)
                        }
                        .tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .frame(maxHeight: 250)
            .padding(.top, -70)
            .onChange(of: viewModel.items.count) { oldValue, newValue in
                if newValue == 0 {
                    currentIndex = 0
                } else if currentIndex >= newValue {
                    currentIndex = max(0, newValue - 1)
                }
            }
            
            HStack(spacing: 6) {
                ForEach(0..<(max(viewModel.items.count, 1)), id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.black : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.1))
            )
            .padding(.bottom, 45)
        }
        .frame(height: 250)
        .animation(.easeInOut, value: currentIndex)
        .onAppear { viewModel.load() }
    }
}

#Preview {
    SliderView()
}
