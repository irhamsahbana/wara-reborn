//
//  CustomAlertView.swift
//  Wara
//
//  Custom alert dialog with adaptive color support
//

import SwiftUI

struct CustomAlertView: View {
    let title: String
    let message: String
    let cancelText: String
    let destructiveText: String
    let onCancel: () -> Void
    let onDestructive: () -> Void
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }
            
            // Alert card
            VStack(spacing: 0) {
                // Title
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.horizontal, 16)
                
                // Message
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                
                Divider()
                
                // Buttons
                HStack(spacing: 0) {
                    // Cancel button
                    Button(action: onCancel) {
                        Text(cancelText)
                            .font(.body.weight(.semibold))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    
                    Divider()
                        .frame(height: 44)
                    
                    // Destructive button
                    Button(action: onDestructive) {
                        Text(destructiveText)
                            .font(.body.weight(.semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemBackground))
            )
            .frame(maxWidth: 270)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        }
    }
}

#Preview {
    CustomAlertView(
        title: "Remove from Saved Products",
        message: "Remove 'Sample Product' from your saved products?",
        cancelText: "Cancel",
        destructiveText: "Remove",
        onCancel: {},
        onDestructive: {}
    )
}
