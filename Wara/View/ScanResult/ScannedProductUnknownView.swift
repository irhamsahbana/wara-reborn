//
//  ScanResultUnknownView.swift
//  Wara
//
//  Created by Meow on 12/11/25
//

import SwiftUI

struct ScanResultUnknownView: View {
    let onRescan: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image("girlNotFound")
                .resizable()
                .scaledToFit()
                .frame(height: 160)

            Text("Oops! We couldn’t detect any Korean text.\nTry scanning a product with Korean ingredients text (한글).")
                .font(.body.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, 24)

            VStack(spacing: 12) {
                Button("Re-scan") {
                    onRescan()
                }
                .buttonStyle(PrimaryButtonStyle(backgroundColor: Color.waraPrimary))
                .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 24)
        .padding(.bottom, 32)
    }
}

#Preview {
    ScanResultUnknownView(
        onRescan: {}
    )
}
