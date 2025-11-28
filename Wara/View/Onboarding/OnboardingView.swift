//
//  Onboarding.swift
//  Wara Onboarding
//
//  Created by Delilah Mentari on 22/06/25.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - Bindings
    @Binding var hasCompletedOnboarding: Bool
    
    // MARK: - States
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    OnboardingTabView(
                        title: "Check Food Halal Status Easily",
                        imageName: "Onboarding1",
                        description: "Wara helps you find out whether a Korean packaged food is safe to consume, doubtful, or non-halal — all with just one quick scan."
                    )
                    .tag(0)
                    
                    OnboardingTabView(
                        title: "Simply Capture the Product Label",
                        imageName: "Onboarding2",
                        description: "Take a clear photo of the front or back of the Korean food package. Our system will automatically recognize and analyze the ingredients for you."
                    )
                    .tag(1)
                    
                    OnboardingTabView(
                        title: "Get Instant and Accurate Results",
                        imageName: "Onboarding3",
                        description: "Each product is classified by its halal status: Safe to Consume, Doubtful, or Non-Halal. Helping you make wiser food choices based on the ingredients inside."
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .padding(.vertical, 8)
                
                // Tombol Next/Mulai Sekarang seperti mockup
                Group {
                    if selectedTab == 2 {
                        NavigationLink(
                            destination: CameraPermissionView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        ) {
                            Text("Next")
                        }
                        .buttonStyle(
                            PrimaryButtonStyle(
                                backgroundColor: Color.waraPrimary,
                                cornerRadius: 28
                            )
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                    } else {
                        Button("Next") {
                            withAnimation(.easeInOut) {
                                selectedTab = min(selectedTab + 1, 2)
                            }
                        }
                        .buttonStyle(
                            PrimaryButtonStyle(
                                backgroundColor: Color.waraPrimary,
                                cornerRadius: 28
                            )
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 24)
                    }
                }
            }
            .background(Color.waraBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    @Previewable @State  var hasCompletedOnboarding = false
    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
}
