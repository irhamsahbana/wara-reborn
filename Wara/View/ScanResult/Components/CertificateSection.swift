//
//  CertificateSection.swift
//  Wara
//
//  Created by Meow on 28/11/25.
//

import SwiftUI

/// Section showing KMF certificate information
struct CertificateSection: View {
    let isKMF: Bool
    let certificateNo: String
    let certificateValid: String
    
    var body: some View {
        if isKMF {
            CardView(backgroundColor: Color.waraChipBackground, aligment: .leading, width: .infinity) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Certificate No:")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)

                    Text(certificateNo)
                        .font(.caption)
                        .foregroundColor(.primary)

                    Text("Certificate Valid:")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)

                    Text(certificateValid)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ScrollView {
        CertificateSection(
            isKMF: true,
            certificateNo: "KMFHC22-0254",
            certificateValid: "2022-08-29 ~ 2025-08-28"
        )
    }
    .background(Color.waraBackground)
}
