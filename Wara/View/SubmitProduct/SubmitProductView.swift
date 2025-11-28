//
//  SwiftUIView.swift
//  Wara
//
//  Created by Meow on 01/11/25.
//

import SwiftUI

struct SubmitProductView: View {
    @Binding var isPresented: Bool
    
    struct StepIndicator: View {
        var isActive: Bool
        var isLast: Bool

        var body: some View {
            VStack(spacing: 0) {
                Circle()
                    .strokeBorder(isActive ? Color.blue : Color.gray.opacity(0.4), lineWidth: 2)
                    .background(Circle().fill(Color.white))
                    .frame(width: 20, height: 20)
                
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 2)
                        .frame(width: 2, height: 90)
                }
            }
        }
    }

    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    isPresented.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 1)
                                .shadow(color: Color.white.opacity(0.9), radius: 3, x: -1, y: -1)
                        )
                }
                
                Spacer()
                
                // Title
                Text("Submit Product")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.trailing, 34)
                
                Spacer()
            }
            .padding()
            
            CardView(backgroundColor: .white, width: .infinity){
                VStack{
                    HStack{
                        Image("slider1")
                                       .resizable()
                                       .scaledToFit()
                                       .frame(width: 140, height: 240)
                        
                        Image("slider1")
                                       .resizable()
                                       .scaledToFit()
                                       .frame(width: 160, height: 200)
                    }
                    .padding()
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            VStack(alignment: .leading, spacing: 32) {
                        
                        // STEP 1: Product Image
                        HStack(alignment: .top, spacing: 12) {
                            StepIndicator(isActive: true, isLast: false)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Product Image (Front)")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    print("Take Picture tapped")
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("Take Picture")
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        
                        // STEP 2: Review and Confirm
                        HStack(alignment: .top, spacing: 12) {
                            StepIndicator(isActive: false, isLast: true)
                            
                            Text("Review and Confirm")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding(.top, -40)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
            
            CardView(backgroundColor: .white, aligment: .leading, width: .infinity){
                VStack(alignment: .leading, spacing: 12){
                    Text("Data Sharing Notice :")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("TEST")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, -20)
            
            Spacer()
            
            Button("Submit") {
                
            }
            .buttonStyle(PrimaryButtonStyle(
                backgroundColor: Color("waraPrimary")
            ))
            .padding(.horizontal, 16)
        }
        .background(Color.green.opacity(0.1))
    }
}

#Preview {
    SubmitProductView(isPresented: .constant(true))
}
