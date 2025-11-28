//
//  FavoriteView.swift
//  Wara
//
//  Created by Meow on 29/10/25.
//

import SwiftUI

struct FavoriteView: View {
    @State private var selectedTab: CustomSegmentedControl.TabType = .favorite
    
    var body: some View {
            VStack(spacing: 0) {
                Text("Favorite")
                    .foregroundColor(.primary)
                    .font(.body.bold())
                    .padding(.top, 12)
                
                CustomSegmentedControl(selectedTab: $selectedTab)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)

                Spacer()

                VStack{
                    if selectedTab == .favorite {
                        FavoriteProductView()
                    } else {
                        ScannedProductGridView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                

                Spacer()
            }
            .background(Color("waraBackground").ignoresSafeArea())
        }
}

#Preview {
    FavoriteView()
}
