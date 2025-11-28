//
//  ProcessingView.swift
//  Wara
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import SwiftUI

struct ProcessingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 20) {
                ProgressView().scaleEffect(2).progressViewStyle(
                    CircularProgressViewStyle(tint: .white)
                )
                Text("Analyzing Image...").font(.headline).foregroundColor(
                    .white
                )
            }
        }
    }
}
