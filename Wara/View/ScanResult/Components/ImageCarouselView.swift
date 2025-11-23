//
//  ImageCarouselView.swift
//  Wara
//
//  Created by Meow on 31/10/25.
//

import SwiftUI

struct ImageCarouselView: View {
    let isHalalKMF: Bool
    let images: [String]
    
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            // Background card
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .frame(width: 288, height: 276)
            
            VStack(spacing: 12) {
                Spacer()
                Image(images[currentIndex])
                               .resizable()
                               .scaledToFit()
                               .frame(width: 160, height: 200)
                               .animation(.easeInOut, value: currentIndex)
                           
                HStack(spacing: 6) {
                    ForEach(0..<images.count, id: \.self) { index in
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
            
            if images.count > 1 {
                HStack {
                    Button(action: {
                        withAnimation {
                            currentIndex = (currentIndex - 1 + images.count) % images.count
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
                            currentIndex = (currentIndex + 1) % images.count
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                .padding(.horizontal, 12)
            }
            
            // Removed KMF logo overlay as per policy
        }
        .frame(width: 288, height: 276)
    }
}



#Preview {
    ImageCarouselView(
        isHalalKMF: true,
        images: ["slider1", "slider2", "slider3"]
    )
}

