//
//  Untitled.swift
//  Wara
//
//  Created by Meow on 30/10/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var hasBorder: Bool = false
    var borderColor: Color = .blue
    var textColor: Color? = nil
    var cornerRadius: CGFloat = 24
    var isFullWidth: Bool = true
    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 12

    private var effectiveTextColor: Color {
        if let textColor = textColor {
            return textColor
        } else {
            return hasBorder ? borderColor : .white
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(effectiveTextColor)
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
               backgroundColor
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(hasBorder ? borderColor : Color.clear, lineWidth: hasBorder ? 2 : 0)
            )
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

#Preview("PrimaryButtonStyle") {
    VStack(spacing: 16) {
        Button("Filled Button") {}
            .buttonStyle(PrimaryButtonStyle(backgroundColor: .blue))

        Button("Outlined Button") {}
            .buttonStyle(
                PrimaryButtonStyle(
                    backgroundColor: .clear,
                    hasBorder: true,
                    borderColor: .blue,
                    textColor: .black
                )
            )
    }
    .padding()
}
