//
//  CachedRemoteImageView.swift
//  Wara
//
//  Created by Meow on 09/11/25.
//

import SwiftUI
import UIKit

struct CachedRemoteImageView: View {
    let id: String?
    let url: URL?
    let contentMode: ContentMode
    let cornerRadius: CGFloat
    let placeholderColor: Color

    @State private var image: UIImage?
    @State private var isLoading: Bool = false

    init(id: String?, url: URL?, contentMode: ContentMode = .fill, cornerRadius: CGFloat = 12, placeholderColor: Color = .gray.opacity(0.2)) {
        self.id = id
        self.url = url
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.placeholderColor = placeholderColor
    }

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                ProgressView()
            } else {
                Rectangle()
                    .fill(placeholderColor)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.title3)
                            .foregroundColor(.gray)
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .task(id: url) {
            await fetch()
        }
    }

    private func fetch() async {
        guard !isLoading else { return }
        guard let url else { return }
        isLoading = true
        let img = await ImageCacheManager.shared.loadImage(id: id, url: url)
        await MainActor.run {
            self.image = img
            self.isLoading = false
        }
    }
}

struct CachedRemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        CachedRemoteImageView(id: "demo", url: URL(string: "https://picsum.photos/300/200"))
            .frame(width: 200, height: 120)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}