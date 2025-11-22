//
//  CustomSegmentedControl.swift
//  Wara
//
//  Created by Meow on 29/10/25.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedTab: TabType

    enum TabType: String, CaseIterable {
        case favorite = "Favorite Products"
        case saved = "Saved Products"
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabType.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring()) {
                        selectedTab = tab
                    }
                }) {
                    Text(tab.rawValue)
                        .font(.body.weight(.semibold))
                        .foregroundColor(selectedTab == tab ? .primary : .gray)
                        .frame(maxWidth: .infinity, maxHeight: 30)
                        .background(
                            Group {
                                if selectedTab == tab {
                                    Color("green2")
                                } else {
                                        Color.clear
                                }
                            }
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .padding(4)
        .background(Color("chipBackground"))
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
}


