import Foundation
import SwiftUI

//
//  Instruction.swift
//  Wara
//
//  Created by Meow on 08/11/25.
//

struct OnboardingSlide: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}


let slides = [
    OnboardingSlide(
        imageName: "inst1",
        title: "1. Scan Front or Back of the Packaging",
        description: "Take a clear photo of the front or back of the Korean food package. Wara system will automatically try to recognize the product."
    ),
    OnboardingSlide(
        imageName: "inst2",
        title: "2. Identify the Product",
        description: "If the system recognizes it, select the correct product match. If not found, you’ll be asked to scan the back of the package."
    ),
    OnboardingSlide(
        imageName: "inst3",
        title: "3. Fit It in the Frame",
        description: "Keep the ingredient text inside the guide box on screen. When it’s detected, you’ll see a tooltip: “Ingredients found!” press Capture to proceed."
    ),
    OnboardingSlide(
        imageName: "inst4",
        title: "4. Check the Highlight",
        description: "Review if all ingredients are correctly highlighted. If yes tap “Check Ingredients”, if not tap “Re-Scan”."
    ),
    OnboardingSlide(
        imageName: "inst5",
        title: "5. Result (Final Step)",
        description: "View your scan result and see whether the product is safe or doubtful or non halal."
    )
]

struct OnboardingSlideView: View {
    let currentIndex: Int
    let slide: OnboardingSlide
    
    var body: some View {
        VStack(spacing: 0) {
            Image(slide.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 260)
            
            if(currentIndex == 0){
                HStack{
                    Text("Front")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.leading, 30)
                    
                    Spacer()
                    
                    Text("Back")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.trailing, 30)
                }
                .padding(.bottom, 8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(slide.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(slide.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }
}



struct InstructionView: View {
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(spacing: 20) {
            
            TabView(selection: $currentIndex) {
                ForEach(Array(slides.enumerated()), id: \.offset) { index, slide in
                    OnboardingSlideView(currentIndex: currentIndex, slide: slide)
                        .tag(index)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 500)
            
            // ✅ Custom Indicator with Dark Mode Support
            HStack(spacing: 8) {
                ForEach(0..<slides.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.primary : Color.secondary.opacity(0.4))
                        .frame(width: index == currentIndex ? 10 : 8,
                               height: index == currentIndex ? 10 : 8)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color(.secondarySystemBackground)) // ✅ adaptif
            .clipShape(Capsule())
            
        }
        .padding(.bottom, 20)
        .background(Color(.systemBackground)) // ✅ adaptif
        .animation(.easeInOut, value: currentIndex)
    }
}


#Preview {
    InstructionView()
}
