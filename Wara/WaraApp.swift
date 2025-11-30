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
    @State private var shouldShowCaptureView: Bool = false

    init() {
        // Initialize user at app launch (skip during SwiftUI Previews)
    }

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding || shouldShowCaptureView {
                CaptureView()
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenScanView"))) { _ in
                        // Handle App Intent to show capture view
                        shouldShowCaptureView = true
                        hasCompletedOnboarding = true
                    }
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OpenScanView"))) { _ in
                        // Handle App Intent to show capture view
                        shouldShowCaptureView = true
                        hasCompletedOnboarding = true
                    }
            }
        }
        // .modelContainer(persistenceController.container)
    }
}
