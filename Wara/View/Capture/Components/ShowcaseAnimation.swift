//
//  ShowcaseAnimation.swift
//  Wara
//
//  Created by Elvis on 26/06/25.
//

import SwiftUI

struct ShowcaseAnimation: View {
    @Binding var isShowcaseAnimation: Bool
    
    enum AnimationState {
        case initial, scalingUp, flipping, showingPhone, capturePhoto, resetting
    }
    
    @State private var animationState: AnimationState = .initial
    
    @State private var isShowPackagedFood = false
    
    @State private var isFlipped = false
    @State private var frontOpacity = 1.0
    @State private var backOpacity = 0.0
    @State private var isShutterClicked = false
    
    @State private var isPhoneAppear = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("PackagedFoodBack")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .opacity(backOpacity)
                
                Image("PackagedFoodFront")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .rotation3DEffect(.degrees(isFlipped ? -180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                    .opacity(frontOpacity)
            }
            .frame(width: 120)
            .scaleEffect(isShowPackagedFood ? 1 : 0.5)
            .opacity(isShowPackagedFood ? 1 : 0)
            .position(x: geo.size.width/2, y: geo.size.height/2)
            
            ZStack {
                Image("Phone")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(
                        Rectangle()
                            .fill(Color.waraAccent)
                            .cornerRadius(32)
                            .opacity(0.1)
                    )
                    .overlay(alignment: .bottom) {
                        Image("CameraShutterButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .padding(.bottom, 24)
                            .opacity(isShutterClicked ? 0 : 1)
                            .animation(.easeInOut(duration: 0.3), value: isShutterClicked)
                    }
                
            }
            .frame(width: 160)
            .opacity(isPhoneAppear ? 1 : 0)
            .position(x: isPhoneAppear ? geo.size.width/2 : geo.size.width, y: geo.size.height/2)
            .onAppear(perform: triggerAnimationSequence)
        }
    }
    
    private func triggerAnimationSequence() {
        switch animationState {
            
        case .initial:
            // 1. Scale up the card
            withAnimation(.bouncy(duration: 0.8)) {
                isShowPackagedFood = true
            } completion: {
                animationState = .scalingUp
                triggerAnimationSequence()
            }
            
        case .scalingUp:
            // 2. Flip the card
            withAnimation(.bouncy(duration: 2).delay(1)) {
                isFlipped = true
            } completion: {
                animationState = .flipping
                triggerAnimationSequence()
            }
            withAnimation(.linear(duration: 0.01).delay(1.4)) {
                frontOpacity = 0
                backOpacity = 1
            }
            
        case .flipping:
            // 3. Show the phone
            withAnimation(.bouncy(duration: 1)) {
                isPhoneAppear = true
            } completion: {
                animationState = .showingPhone
                triggerAnimationSequence()
            }
            
        case .showingPhone:
            // 4. Reset everything to start the loop again
            withAnimation(.easeInOut(duration: 1).delay(2)) {
                
            } completion: {
                // Go back to the initial state and restart the sequence
                animationState = .capturePhoto
                triggerAnimationSequence()
            }
            
        case .capturePhoto:
            withAnimation(.easeInOut(duration: 0.1).delay(1)) {
                isShutterClicked.toggle()
            } completion: {
                isShutterClicked.toggle()
                animationState = .resetting
                triggerAnimationSequence()
            }
            
        case .resetting:
            withAnimation(.easeInOut(duration: 1).delay(1)) {
                isPhoneAppear = false
                isFlipped = false
                isShowPackagedFood = false
                frontOpacity = 1
                backOpacity = 0
            } completion: {
                isShowcaseAnimation = false
            }
        }
    }
}

