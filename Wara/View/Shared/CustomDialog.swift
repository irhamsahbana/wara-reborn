//
//  CustomDialog.swift
//  Wara
//
//  Created by Meow on 07/11/25.
//

import SwiftUI

struct CustomDialog<DialogContent: View>: ViewModifier {
    @Binding var isShown: Bool
    let dialogContent: DialogContent

    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        ZStack {
            content

            if isShown {
                // Dim Background (adapt transparency)
                Color.black.opacity(colorScheme == .dark ? 0.6 : 0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            isShown = false
                        }
                    }
                    .zIndex(1)

                // Dialog Box (adapt to system)
                dialogContent
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground)) // <-- Adaptive
                            .shadow(color: Color.primary.opacity(0.15), radius: 12)
                    )
                    .padding(.horizontal, 32)
                    .transition(.scale)
                    .zIndex(2)
            }
        }
        .animation(.easeInOut, value: isShown)
    }
}

extension View {
    func customDialog<DialogContent: View>(
        isShown: Binding<Bool>,
        @ViewBuilder dialogContent: () -> DialogContent
    ) -> some View {
        self.modifier(CustomDialog(isShown: isShown, dialogContent: dialogContent()))
    }
}
