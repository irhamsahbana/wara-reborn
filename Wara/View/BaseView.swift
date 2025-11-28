//
//  BaseView.swift
//  Wara
//
//  Created by Meow on 20/10/25.
//

import SwiftUI

struct BaseView: View {
    @State private var selectedTab: Int = 0
    @State private var showCamera: Bool = false

    var body: some View {
        NavigationStack{
            TabView(selection: $selectedTab) {
                FoodListView()
                    .tabItem {
                        Image(systemName: "fork.knife")
                        Text("Food")
                    }
                    .tag(0)

                Text("")
                    .tabItem {
                        Image(systemName: "camera.fill")
                        Text("Scan")
                    }
                    .tag(1)

                FavoriteView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favorite")
                    }
                    .tag(2)
            }
            .accentColor(Color("primaryblue"))
            .background(Color("background"))
            .onChange(of: selectedTab) {
                if selectedTab == 1 {
                    showCamera = true
                    selectedTab = 0
                }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CaptureView()
            }
        }
    }
}

#Preview {
    BaseView()
}
