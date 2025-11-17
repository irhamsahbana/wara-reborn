//
//  Camerapermission.swift
//  Wara Onboarding
//
//  Created by Delilah Mentari on 22/06/25.
//

import SwiftUI
import AVFoundation

struct CameraPermissionView: View {
    // MARK: - Bindings
    @Binding var hasCompletedOnboarding: Bool
    
    // MARK: - Methods
    private func requestCameraPermission() {
        // Skip actual permission prompt during SwiftUI Previews
        if Env.isPreview {
            hasCompletedOnboarding = true
            return
        }
        AVCaptureDevice.requestAccess(for: .video) { granted in }
        hasCompletedOnboarding = true
    }
    
    var body: some View {
        VStack() {
            VStack (alignment: .center, spacing: 32) {
                Spacer()
                
                Image("Onboarding4")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 320)
                    .frame(height: 200)
                    .clipped()
                
                VStack (spacing: 16) {
                    Text("Ready to Start Scanning?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Allow camera access to scan Korean food packages around you.")
                        .foregroundColor(Color("MutedText"))
                        .font(.callout)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            
            Button(action: requestCameraPermission) {
                Text("Continue")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color("primaryblue"))
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    @Previewable @State var hasCompletedOnboarding: Bool = false
    CameraPermissionView(hasCompletedOnboarding: $hasCompletedOnboarding)
}
