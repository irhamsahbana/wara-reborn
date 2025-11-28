//
//  FullscreenImageView.swift
//  Wara
//
//  Created by AI Assistant
//

import SwiftUI
import UIKit

/// Fullscreen image viewer with zoom and swipe capabilities.
///
/// **Features:**
/// - Pinch-to-zoom (1x to 4x)
/// - Swipe between multiple images
/// - Double-tap to zoom in/out
/// - Tap to dismiss
///
/// **Gestures:**
/// - Single tap: Close fullscreen view
/// - Double tap: Toggle zoom (1x ↔ 2x)
/// - Pinch: Zoom between 1x and 4x
/// - Drag: Pan when zoomed in, or swipe to next/previous image
struct FullscreenImageView: View {
    let imageURLs: [URL]
    let fallbackImage: UIImage?
    let initialIndex: Int
    @Binding var isPresented: Bool
    
    @State private var currentIndex: Int
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var magnifyBy = 1.0
    @GestureState private var dragOffset: CGSize = .zero
    
    init(imageURLs: [URL], fallbackImage: UIImage?, initialIndex: Int, isPresented: Binding<Bool>) {
        self.imageURLs = imageURLs
        self.fallbackImage = fallbackImage
        self.initialIndex = initialIndex
        self._isPresented = isPresented
        self._currentIndex = State(initialValue: initialIndex)
    }
    
    private var finalScale: CGFloat {
        scale * magnifyBy
    }
    
    private var finalOffset: CGSize {
        CGSize(
            width: offset.width + dragOffset.width,
            height: offset.height + dragOffset.height
        )
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                // Close button
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                
                Spacer()
                
                // Image viewer
                GeometryReader { geometry in
                    ZStack {
                        if imageURLs.indices.contains(currentIndex) {
                            CachedRemoteImageView(
                                id: nil,
                                url: imageURLs[currentIndex],
                                contentMode: .fit,
                                cornerRadius: 0,
                                placeholderColor: Color.clear
                            )
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        } else if let local = fallbackImage {
                            Image(uiImage: local)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                    .scaleEffect(finalScale)
                    .offset(finalOffset)
                    .gesture(zoomGesture)
                    .simultaneousGesture(panGesture)
                    .onTapGesture(count: 2) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            if scale > 1.0 {
                                resetZoom()
                            } else {
                                scale = 2.0
                            }
                        }
                    }
                    .onTapGesture(count: 1) {
                        if scale == 1.0 {
                            isPresented = false
                        }
                    }
                }
                
                Spacer()
                
                // Page indicator
                if imageURLs.count > 1 {
                    HStack(spacing: 8) {
                        ForEach(0..<imageURLs.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.white : Color.white.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .statusBar(hidden: true)
    }
    
    // MARK: - Gestures
    
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($magnifyBy) { value, gestureState, _ in
                gestureState = value
            }
            .onEnded { value in
                var newScale = scale * value
                newScale = min(max(newScale, 1.0), 4.0)
                
                withAnimation(.easeOut(duration: 0.2)) {
                    scale = newScale
                    if scale == 1.0 {
                        offset = .zero
                    }
                }
            }
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, gestureState, _ in
                if scale > 1.0 {
                    gestureState = value.translation
                }
            }
            .onEnded { value in
                if scale > 1.0 {
                    // Update permanent offset when zoomed
                    offset = CGSize(
                        width: offset.width + value.translation.width,
                        height: offset.height + value.translation.height
                    )
                } else if imageURLs.count > 1 {
                    // Swipe between images when not zoomed
                    let threshold: CGFloat = 50
                    if value.translation.width < -threshold && currentIndex < imageURLs.count - 1 {
                        withAnimation(.easeOut(duration: 0.2)) {
                            currentIndex += 1
                            resetZoom()
                        }
                    } else if value.translation.width > threshold && currentIndex > 0 {
                        withAnimation(.easeOut(duration: 0.2)) {
                            currentIndex -= 1
                            resetZoom()
                        }
                    }
                }
            }
    }
    
    // MARK: - Helpers
    
    private func resetZoom() {
        scale = 1.0
        offset = .zero
    }
}

#Preview {
    FullscreenImageView(
        imageURLs: [
            URL(string: "https://picsum.photos/400/600")!,
            URL(string: "https://picsum.photos/400/601")!
        ],
        fallbackImage: nil,
        initialIndex: 0,
        isPresented: .constant(true)
    )
}
