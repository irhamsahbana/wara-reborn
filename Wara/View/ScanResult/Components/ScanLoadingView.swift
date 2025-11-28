//
//  ScanLoadingView.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI

/// Loading state view shown during scan analysis
struct ScanLoadingView: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Image(ImageAssets.searchingPackagedFood)
                .resizable()
                .scaledToFit()
                .frame(height: 140)

            VStack(spacing: 6) {
                Text("Analyzing ingredients carefully...")
                    .font(.body.weight(.semibold))
                    .foregroundColor(.primary)
                Text("This might take just a few seconds!")
                    .font(.body.weight(.semibold))
                    .foregroundColor(.primary)
            }

            ProgressGradientBar(progress: progress)
                .padding(.horizontal, 24)
                .animation(.easeInOut(duration: 0.25), value: progress)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    ScanLoadingView(progress: 0.65)
}
