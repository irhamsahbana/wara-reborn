//
//  OnboardingButton.swift
//  Wara
//
//  Created by Elvis on 25/06/25.
//

import SwiftUI

struct OnboardingButton: View {
    // MARK: - Bindings
    @Binding var selectedTab: Int
    @Binding var hasCompletedOnboarding: Bool
    
    // MARK: - Methods
    private func nextTab() {
        withAnimation {
            selectedTab += 1
        }
    }
    
    var body: some View {
        if selectedTab == 2 {
            NavigationLink(destination: CameraPermissionView(hasCompletedOnboarding: $hasCompletedOnboarding)) {
                Text("Mulai Sekarang")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("waraPrimary"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            
        } else {
            Button(action: nextTab) {
                Text("Selanjutnya")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("waraPrimary"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }
}
