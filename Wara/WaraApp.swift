//
//  WaraApp.swift
//  Wara
//
//  Created by Immanuel Sitepu on 13/06/25.
//

import SwiftUI
import SwiftData

@main
struct WaraApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    init() {
        // Initialize user at app launch (skip during SwiftUI Previews)
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                CaptureView()
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        // .modelContainer(persistenceController.container)
    }
}
