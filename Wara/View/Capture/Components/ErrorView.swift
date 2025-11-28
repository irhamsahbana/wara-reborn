//
//  ErrorView.swift
//  Wara
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill").font(
                .system(size: 60)
            ).foregroundColor(.yellow)
            Text("Something Went Wrong").font(.title.bold())
            Text(message).font(.body).multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Button("Try Again", action: onDismiss)
                .font(.headline).foregroundColor(.white).padding()
                .background(Color.blue).cornerRadius(12)
        }
        .padding(30).frame(maxWidth: 300)
        .background(Color(.systemBackground)).cornerRadius(20).shadow(
            radius: 10
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea())
    }
}
