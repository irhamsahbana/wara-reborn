//
//  ScanErrorView.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI

/// Error state view shown when scan fails
struct ScanErrorView: View {
    let errorMessage: String
    let onBack: () -> Void
    
    private var isServerError: Bool {
        errorMessage.contains("server is busy") || errorMessage.contains("try again later")
    }
    
    private var isNoInternetError: Bool {
        errorMessage.contains("No internet connection") || errorMessage.contains("check your network")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 20) {
                if isServerError {
                    Image(ImageAssets.serverError)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                        .padding(.bottom, 8)
                    
                    Text("Oops! The server is busy right now.")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Please try again later.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                } else if isNoInternetError {
                    Image(ImageAssets.serverError)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                        .padding(.bottom, 8)
                    
                    Text("Oops! No internet connection detected.")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("Please check your network and try again.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            Button("Back") {
                onBack()
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: Color.waraPrimary))
            .padding(.bottom, 40)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ScanErrorView(
        errorMessage: "Failed to analyze product. Please try again.",
        onBack: {}
    )
}
