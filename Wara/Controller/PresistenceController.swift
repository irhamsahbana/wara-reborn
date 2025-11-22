//
//  Controller.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import Foundation
import SwiftData
import OSLog

@MainActor
/// Mengelola SwiftData `ModelContainer` dan memuat ulang database dari `Ingredients.json` bila diperlukan.
class PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer?
    
    private init() {
        // container = try ModelContainer(for: Ingredient.self)
        container = nil
    }

    /// Fungsi ini hanya akan berjalan di background dan terisolasi.
    private func forceReloadDatabaseIfNeeded(using container: ModelContainer) async {
        // Skip heavy I/O during SwiftUI Previews to avoid PreviewShell crashes
        if Env.isPreview {
            os_log("[PersistenceController] Skipping DB reload in Previews", type: .info)
            return
        }
        // 3. Buat context khusus untuk background dari container yang diberikan
        let backgroundContext = ModelContext(container)
        
        guard let url = Bundle.main.url(forResource: "Ingredients", withExtension: "json") else {
            os_log("[PersistenceController] Ingredients.json not found in bundle", type: .error)
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let dtos = try JSONDecoder().decode([IngredientDTO].self, from: data)
            
            // Cek jumlah data untuk efisiensi
            let descriptor = FetchDescriptor<Ingredient>()
            let currentCount = (try? backgroundContext.fetchCount(descriptor)) ?? -1
            if currentCount == dtos.count {
                print("Database is up to date. No update needed.")
                return
            }
            
            print("Database requires update. Wiping and reloading...")
            
            // 4. Lakukan semua operasi (hapus, tambah, simpan) di background context
            try backgroundContext.delete(model: Ingredient.self)
            
            for dto in dtos {
                let newIngredient = Ingredient(
                    koreanName: dto.koreanName,
                    pronunciation: dto.pronunciation,
                    englishName: dto.englishName,
                    descriptionText: dto.descriptionText,
                    category: dto.category
                )
                backgroundContext.insert(newIngredient)
            }
            
            try backgroundContext.save()
            print("Successfully reloaded \(dtos.count) ingredients.")
            
        } catch {
            os_log("[PersistenceController] Failed to reload DB from JSON: %{public}@", type: .error, String(describing: error))
        }
    }
}
