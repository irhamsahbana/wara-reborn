//
//  OnboardingPageView.swift
//  Wara Onboarding
//
//  Created by Delilah Mentari on 22/06/25.
//

import SwiftUI

struct OnboardingTabView: View {
    let title: String
    let imageName: String
    let description: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(24)
            
            Text(title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(description)
                .font(.callout)
                .foregroundColor(.waraMutedText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
