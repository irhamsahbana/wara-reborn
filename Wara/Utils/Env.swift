// Env.swift
// Wara
// Created by Meow on 02/11/25

import Foundation

/// Utilitas untuk mendeteksi environment (SwiftUI Previews/UI tests) agar inisialisasi tertentu dapat dilewati.
enum Env {
    /// Detects when running inside SwiftUI Previews or UI tests.
    static var isPreview: Bool {
        let env = ProcessInfo.processInfo.environment
        if env["XCODE_RUNNING_FOR_PREVIEWS"] == "1" { return true }
        // Fallback: some preview hosts set this flag differently; also treat XCTest as preview-like.
        if env["SWIFTUI_PREVIEWS_ENVIRONMENT"] == "1" { return true }
        if NSClassFromString("XCTestCase") != nil { return true }
        return false
    }

    static var apiBaseURL: String {
        let baseRaw = (Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String) ?? ""
        let base = baseRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        if !base.isEmpty {
            return base
        }

        let schemeRaw = (Bundle.main.object(forInfoDictionaryKey: "API_SCHEME") as? String) ?? ""
        let hostRaw = (Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String) ?? ""
        let scheme = schemeRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        let hostVal = hostRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        precondition(!scheme.isEmpty, "API_SCHEME missing.")
        precondition(!hostVal.isEmpty, "API_HOST missing.")
        precondition(scheme == "http" || scheme == "https", "API_SCHEME must be 'http' or 'https'.")

        var host = hostVal
        var port: Int? = nil
        if let colonIndex = host.firstIndex(of: ":") {
            let hostname = String(host[..<colonIndex])
            let portStr = String(host[host.index(after: colonIndex)...])
            host = hostname
            if let p = Int(portStr) { port = p }
        }

        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        guard let url = components.url else {
            preconditionFailure("Invalid API_SCHEME/API_HOST combination.")
        }
        return url.absoluteString
    }
}
