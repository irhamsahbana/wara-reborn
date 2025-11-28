//
//  ChipButton.swift
//  Wara
//
//  Created by Meow on 20/10/25.
//

import SwiftUI

struct ChipButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.all, 10)
                .padding(.horizontal, 4)
                .background(isSelected ? Color("green1") : Color("chipBackground"))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("green1"), lineWidth: 4)
                )
                .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    ChipButton(label: "Halal", isSelected: true) {
        print("Chip tapped")
    }
}
