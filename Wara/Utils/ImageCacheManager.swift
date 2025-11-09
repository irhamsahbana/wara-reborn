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
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // ~50MB
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
        if let data = try? Data(contentsOf: fileURL), let img = UIImage(data: data) {
            memoryCache.setObject(img, forKey: key as NSString)
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
            memoryCache.setObject(img, forKey: key as NSString)
        }
    }

    /// Loads an image: checks cache first, otherwise downloads and caches it.
    func loadImage(id: String?, url: URL) async -> UIImage? {
        let key = key(for: id, urlString: url.absoluteString)

        if let cached = cachedImage(forKey: key) {
            return cached
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            store(data: data, forKey: key)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
}