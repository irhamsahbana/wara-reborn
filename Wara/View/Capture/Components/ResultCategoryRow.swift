//
//  ResultCategoryRow.swift
//  Wara
//
//  Created by Immanuel Sitepu on 25/06/25.
//

import SwiftUI

struct ResultCategoryRow: View {
    let icon: String
    let color: Color
    let title: String
    let count: Int

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: icon).foregroundColor(color).font(.title2).frame(width: 30)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline).foregroundColor(.primary)
                    Text("\(count) bahan").font(.subheadline).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.subheadline.bold()).foregroundColor(.secondary.opacity(0.5))
            }
            .padding(.vertical, 16)
            Divider()
        }
    }
}
