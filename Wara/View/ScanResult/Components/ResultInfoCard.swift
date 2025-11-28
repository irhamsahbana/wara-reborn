//
//  ResultInfoCard.swift
//  Wara
//
//  Created by Meow on 31/10/25.
//

import SwiftUI

struct ResultInfoCard: View {
    let productType: ProductType
    let statusMessage: String
    
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
                    description: statusMessage.isEmpty ? "No haram ingredient found" : statusMessage,
                    color: Color("waraHalal"),
                    icon: "checkmark"
                )
            }
            
            if(productType == .SAFE_TO_CONSUME){
                InfoCard(
                    title: ProductType.SAFE_TO_CONSUME.rawValue,
                    description: statusMessage.isEmpty ? "No haram ingredient found" : statusMessage,
                    color: Color("waraHalal"),
                    icon: "checkmark"
                )
            }
            
            if(productType == .DOUBTFULL){
                InfoCard(
                    title: ProductType.DOUBTFULL.rawValue,
                    description: statusMessage.isEmpty ? "Requires further checking" : statusMessage,
                    color: Color("waraAlertYellow"),
                    icon: "exclamationmark"
                )
            }
            
            if(productType == .NON_HALAL){
                InfoCard(
                    title: ProductType.NON_HALAL.rawValue,
                    description: statusMessage.isEmpty ? "Contains forbidden ingredients" : statusMessage,
                    color: Color("waraAlertRed"),
                    icon: "xmark"
                )
            }
        }
    }
}

#Preview {
    ResultInfoCard(
        productType: .NON_HALAL,
        statusMessage: "Contains forbidden ingredients"
    )
}
