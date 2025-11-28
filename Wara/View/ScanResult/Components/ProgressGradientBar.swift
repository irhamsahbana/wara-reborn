//
//  ProgressGradientBar.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI

/// Animated gradient progress bar used during scanning
struct ProgressGradientBar: View {
    let progress: Double // 0.0 ... 1.0

    private var clamped: Double { max(0.0, min(progress, 1.0)) }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color("green2"), Color("yellow")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * clamped)
            }
        }
        .frame(height: 12)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressGradientBar(progress: 0.0)
        ProgressGradientBar(progress: 0.3)
        ProgressGradientBar(progress: 0.7)
        ProgressGradientBar(progress: 1.0)
    }
    .padding()
}
