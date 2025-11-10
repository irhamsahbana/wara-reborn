//
//  ResultInfoCard.swift
//  Wara
//
//  Created by Meow on 31/10/25.
//

import SwiftUI

struct ResultInfoCard: View {
    let productType: ProductType
    
    struct InfoCard: View {
        let title: String
        let description: String
        let color: Color
        let icon: String
        
        var body: some View {
            VStack{
                HStack{
                    ZStack{
                        Circle()
                            .fill(color)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle().stroke(Color.black, lineWidth: 2)
                            )

                        
                        Image(systemName: icon)
                            .font(.caption2.weight(.bold))
                            .foregroundColor(.black)
                    }
                    
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.black)
                }
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.black)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
            )
        }
    }
    
    var body: some View {
        VStack{
            if(productType == .HALAL){
                InfoCard(
                    title: ProductType.HALAL.rawValue,
                    description: "No haram ingredient found",
                    color: Color("green2"),
                    icon: "checkmark"
                )
            }
            
            if(productType == .SAFE_TO_CONSUME){
                InfoCard(
                    title: ProductType.SAFE_TO_CONSUME.rawValue,
                    description: "No haram ingredient found",
                    color: Color("green2"),
                    icon: "checkmark"
                )
            }
            
            if(productType == .DOUBTFULL){
                InfoCard(
                    title: ProductType.DOUBTFULL.rawValue,
                    description: "Requires further checking",
                    color: Color("yellow"),
                    icon: "exclamationmark"
                )
            }
            
            if(productType == .NON_HALAL){
                InfoCard(
                    title: ProductType.NON_HALAL.rawValue,
                    description: "Contains forbidden ingredients",
                    color: Color("red"),
                    icon: "xmark"
                )
            }
        }
    }
}

#Preview {
    ResultInfoCard(
        productType: .NON_HALAL
        
    )
}
