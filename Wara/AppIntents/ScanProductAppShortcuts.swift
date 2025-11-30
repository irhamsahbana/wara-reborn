//
//  ScanProductAppShortcuts.swift
//  Wara
//
//  Created for App Intents integration
//

import AppIntents

/// Defines app shortcuts that expose Wara's scanning functionality to Siri, Shortcuts, and Spotlight
///
/// **Available Phrases:**
/// - "Scan product with Wara"
/// - "Open Wara to scan"
/// - "Scan ingredients with Wara"
///
/// These shortcuts allow users to quickly access the product scanning feature
/// through voice commands, the Shortcuts app, or Spotlight search.
struct ScanProductAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ScanProductIntent(),
            phrases: [
                "Scan product with \(.applicationName)",
                "Open \(.applicationName) to scan",
                "Scan ingredients with \(.applicationName)"
            ],
            shortTitle: "Scan Product",
            systemImageName: "camera.viewfinder"
        )
    }
}
