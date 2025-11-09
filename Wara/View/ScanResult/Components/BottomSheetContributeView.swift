//
//  BottomSheetView.swift
//  Wara
//
//  Created by Meow on 31/10/25.
//

import SwiftUI

struct BottomSheetContributeView: View {
    @Binding var isPresented: Bool
    @State private var showForm = false
    
    struct RoundedCorner: Shape {
        var radius: CGFloat = 0.0
        var corners: UIRectCorner = .allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Text("Help Us Grow the List!")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .font(.subheadline.weight(.semibold))
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("**Looks like this product’s new to us!**\nSubmit it so our team can review and verify the ingredients.")
                    .font(.body)
                    .foregroundColor(.black)

                HStack(alignment: .top, spacing: 12) {
                    Image("scan") 
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .cornerRadius(12)

                    Text("By sharing this, you help others halal chingu discover safe and halal food choices.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }

            Spacer(minLength: 10)

            Button("Contribute Now!") {
                showForm = true
            }
            .buttonStyle(PrimaryButtonStyle(
                backgroundColor: Color("primaryblue")
            ))
            .padding(.top, 4)
            .fullScreenCover(isPresented: $showForm) {
                SubmitProductView(
                    isPresented: $showForm
                )
            }

        }
        .padding(24)
        .background(
            Color.white
                .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
                .shadow(radius: 10)
        )
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .ignoresSafeArea(edges: .bottom)
    }
}

