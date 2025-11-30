//
//  ScanProductIntent.swift
//  Wara
//
//  Created for App Intents integration
//

import AppIntents
import SwiftUI

/// App Intent that allows users to open Wara and start scanning products via Siri
///
/// **Usage:**
/// - Siri: "Scan product with Wara"
/// - Shortcuts app: Add "Scan Product" shortcut
/// - Spotlight: Search for "scan product"
///
/// **Behavior:**
/// When triggered, this intent opens the Wara app and navigates to the CaptureView
/// for scanning product ingredients.
struct ScanProductIntent: AppIntent {
    static var title: LocalizedStringResource = "Scan Product"
    
    static var description = IntentDescription("Open Wara to scan a product's ingredients")
    
    static var openAppWhenRun: Bool = true
    
    /// Performs the intent action
    /// - Returns: An intent result that opens the app
    @MainActor
    func perform() async throws -> some IntentResult {
        // Post a notification to trigger navigation to CaptureView
        NotificationCenter.default.post(
            name: NSNotification.Name("OpenScanView"),
            object: nil
        )
        
        return .result()
    }
}
