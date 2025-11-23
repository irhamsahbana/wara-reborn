//
//  ImageCacheManager.swift
//  Wara
//
//  Created by Meow on 09/11/25.
//

import Foundation
import UIKit
import CryptoKit

actor ImageCacheManager {
    static let shared = ImageCacheManager()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let ttl: TimeInterval = 14 * 24 * 60 * 60

    private init() {
        let base = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = base.appendingPathComponent("ImageCache", isDirectory: true)
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            } catch {
                // If directory creation fails, caching will silently skip disk writes.
                // We intentionally avoid crashing in release builds.
            }
        }
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 50 * 1024 * 1024
    }

    /// Generates a stable SHA256 key using the product id and URL string.
    func key(for id: String?, urlString: String) -> String {
        let combo = (id ?? "") + "|" + urlString
        let digest = SHA256.hash(data: Data(combo.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    /// Returns a cached image if present in memory or on disk.
    func cachedImage(forKey key: String) -> UIImage? {
        if let img = memoryCache.object(forKey: key as NSString) {
            return img
        }

        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let attrs = try? fileManager.attributesOfItem(atPath: fileURL.path),
           let mod = attrs[.modificationDate] as? Date {
            let age = Date().timeIntervalSince(mod)
            if age > ttl {
                try? fileManager.removeItem(at: fileURL)
                return nil
            }
        }
        if let data = try? Data(contentsOf: fileURL), let img = UIImage(data: data) {
            memoryCache.setObject(img, forKey: key as NSString, cost: data.count)
            return img
        }
        return nil
    }

    /// Stores raw image data to disk and image into memory cache.
    func store(data: Data, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            // Silently ignore disk write errors to avoid crashing.
        }
        if let img = UIImage(data: data) {
            memoryCache.setObject(img, forKey: key as NSString, cost: data.count)
        }
    }

    private func isImageResponse(_ response: URLResponse) -> Bool {
        if let http = response as? HTTPURLResponse,
           let contentType = http.value(forHTTPHeaderField: "Content-Type") {
            return contentType.lowercased().hasPrefix("image/")
        }
        return true
    }

    private func makeRequest(for url: URL) -> URLRequest {
        var r = URLRequest(url: url)
        r.httpMethod = "GET"
        r.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        if let scheme = url.scheme, let host = url.host, !host.isEmpty, host.contains("heechang.com") {
            var referer = "\(scheme)://\(host)"
            if let comps = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let bo = comps.queryItems?.first(where: { $0.name == "bo_table" })?.value,
               !bo.isEmpty {
                referer = "\(scheme)://\(host)/bbs/board.php?bo_table=\(bo)"
            }
            r.setValue(referer, forHTTPHeaderField: "Referer")
            r.setValue("\(scheme)://\(host)", forHTTPHeaderField: "Origin")
        }
        return r
    }

    private func buildCandidates(for url: URL) -> [URL] {
        var list: [URL] = [url]
        if let host = url.host, host.contains("heechang.com"),
           let comps = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let queryItems = comps.queryItems ?? []
            let fnVal = queryItems.first(where: { $0.name == "fn" })?.value ?? ""
            let boVal = queryItems.first(where: { $0.name == "bo_table" })?.value ?? ""
            if fnVal.hasPrefix("/"), let scheme = url.scheme,
               let direct = URL(string: "\(scheme)://\(host)\(fnVal)") {
                list.append(direct)
            } else if !boVal.isEmpty && !fnVal.isEmpty,
                      let scheme = url.scheme,
                      let direct = URL(string: "\(scheme)://\(host)/data/file/\(boVal)/\(fnVal)") {
                list.append(direct)
            }
        }
        return list
    }

    /// Loads an image: checks cache first, otherwise downloads and caches it.
    func loadImage(id: String?, url: URL) async -> UIImage? {
        let key = key(for: id, urlString: url.absoluteString)

        if let cached = cachedImage(forKey: key) {
            return cached
        }

        let candidates = buildCandidates(for: url)
        for u in candidates {
            do {
                let host = u.host ?? ""
                let (data, _) = host.contains("heechang.com")
                    ? try await URLSession.shared.data(for: makeRequest(for: u))
                    : try await URLSession.shared.data(from: u)
                if let img = UIImage(data: data) {
                    store(data: data, forKey: key)
                    return img
                }
            } catch {
                continue
            }
        }
        return nil
    }
}