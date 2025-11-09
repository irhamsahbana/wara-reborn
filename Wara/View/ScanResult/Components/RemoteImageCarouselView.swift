//
//  RemoteImageCarouselView.swift
//  Wara
//
//  Created by Meow on 09/11/25
//

import SwiftUI
import UIKit

struct RemoteImageCarouselView: View {
    let isHalalKMF: Bool
    let imageURLs: [URL]
    let fallbackImage: UIImage?

    @State private var currentIndex = 0

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .frame(width: 288, height: 276)

            VStack(spacing: 12) {
                Spacer()

                if imageURLs.indices.contains(currentIndex) {
                    AsyncImage(url: imageURLs[currentIndex]) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 160, height: 200)
                        case .failure:
                            if let local = fallbackImage {
                                Image(uiImage: local)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160, height: 200)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160, height: 200)
                                    .foregroundColor(.gray)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else if let local = fallbackImage {
                    Image(uiImage: local)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 200)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 200)
                        .foregroundColor(.gray)
                }

                HStack(spacing: 6) {
                    ForEach(0..<max(imageURLs.count, 1), id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.5))
                )
                .padding(.bottom, 8)
            }

            HStack {
                Button(action: {
                    withAnimation {
                        guard !imageURLs.isEmpty else { return }
                        currentIndex = (currentIndex - 1 + imageURLs.count) % imageURLs.count
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                }

                Spacer()

                Button(action: {
                    withAnimation {
                        guard !imageURLs.isEmpty else { return }
                        currentIndex = (currentIndex + 1) % imageURLs.count
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                }
            }
            .padding(.horizontal, 12)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if isHalalKMF {
                        Image("halal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 20)
                            .padding(.trailing, 10)
                    }
                }
            }
        }
        .frame(width: 288, height: 276)
    }
}

#Preview {
    RemoteImageCarouselView(
        isHalalKMF: true,
        imageURLs: [URL(string: "https://via.placeholder.com/300")!],
        fallbackImage: nil
    )
}