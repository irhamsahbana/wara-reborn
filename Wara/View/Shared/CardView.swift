//
//  CardView.swift
//  Wara
//
//  Created by Meow on 31/10/25.
//

import SwiftUI

struct CardView<Content: View>: View {
    var backgroundColor: Color = .white
    var cornerRadius: CGFloat = 16
    var shadowColor: Color = .black.opacity(0.1)
    var shadowRadius: CGFloat = 8
    var padding: CGFloat = 12
    var aligment: Alignment = .center
    var width: CGFloat?
    
    @ViewBuilder var content: Content
    
    var body: some View {
        // Safely resolve width: treat non-finite/negative as default, and
        // support .infinity via maxWidth instead of fixed width.
        let isInfiniteWidth = width?.isInfinite == true
        let resolvedWidth: CGFloat = {
            guard let w = width else { return 160 }
            if w.isNaN || !w.isFinite || w <= 0 { return 160 }
            return w
        }()

        content
            .padding(padding)
            // Gunakan alignment yang diteruskan agar konten bisa rata kiri/kanan sesuai kebutuhan
            .frame(maxWidth: isInfiniteWidth ? .infinity : nil, alignment: aligment)
            .frame(width: isInfiniteWidth ? nil : resolvedWidth, alignment: aligment)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 4)
    }
}
