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
    
    var body: some View {
        VStack(spacing: 12) {
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.primary)
            Button("Back") {
                onBack()
            }
            .buttonStyle(PrimaryButtonStyle(backgroundColor: Color("waraPrimary")))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    ScanErrorView(
        errorMessage: "Failed to analyze product. Please try again.",
        onBack: {}
    )
}
