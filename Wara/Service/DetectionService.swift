//
//  DetectionService.swift
//  HalalLens
//
//  Created by Immanuel Sitepu on 22/06/25.
//

import Foundation
import SwiftData

/// Menganalisis teks OCR, mengekstrak bagian bahan, dan memetakan ke entitas `Ingredient`.
class DetectionService {
    private let modelContext: ModelContext
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Methods
    @MainActor
    func analyzeIngredients(text: String) async -> DetectionResult {
        // Check are the text contain ingredient keyword
        let containsIngredientsLabel = hasIngredientsLabel(in: text)
        
        if (!containsIngredientsLabel) {
            return DetectionResult(status: .ingredientsNotFound, foundIngredients: [], originalText: text)
        }
        
        // Remove line break of OCR result text
        let cleanedText = text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        
        // Extract ingredients part only
        guard let ingredientFullText = self.extractIngredients(from: cleanedText) else {
            return DetectionResult(status: .ingredientsNotFound, foundIngredients: [], originalText: text)
        }
        
        guard let cleanedIngredientFullText = self.removeIngredientExtraInformation(from: ingredientFullText) else {
            return DetectionResult(status: .ingredientsNotFound, foundIngredients: [], originalText: text)
        }

        let descriptor = FetchDescriptor<Ingredient>()
        guard let allIngredients = try? modelContext.fetch(descriptor) else {
            return DetectionResult(status: .raguRagu, foundIngredients: [], originalText: text)
        }
        
        var foundItems: [Ingredient] = []
        for ingredient in allIngredients {
            if cleanedIngredientFullText.contains(ingredient.koreanName) {
                foundItems.append(ingredient)
            }
        }
        
        if foundItems.isEmpty {
            return DetectionResult(status: .aman, foundIngredients: [], originalText: text)
        }
        
        if foundItems.contains(where: { $0.category == .tidakAman }) {
            return DetectionResult(status: .tidakAman, foundIngredients: foundItems, originalText: text)
        } else if foundItems.contains(where: { $0.category == .raguRagu }) {
            return DetectionResult(status: .raguRagu, foundIngredients: foundItems, originalText: text)
        } else {
            return DetectionResult(status: .aman, foundIngredients: foundItems, originalText: text)
        }
    }
    
    func hasIngredientsLabel(in text: String) -> Bool {
        let keyword1 = "원재료" // Raw Materials
        let keyword2 = "원재료명" // Raw Material Name, sering digunakan juga
        return text.contains(keyword1) || text.contains(keyword2)
    }
    
    func extractIngredients(from text: String) -> String? {
        let pattern = "(원재료|원재료명)(.*?)(?=제품명|식품유형|제조원|유통전문|소비기한|원재료명|포장재질|품목보고번호|$)"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
            let nsrange = NSRange(text.startIndex..<text.endIndex, in: text)
            
            if let match = regex.firstMatch(in: text, options: [], range: nsrange) {
                if let range = Range(match.range(at: 2), in: text) {
                    return String(text[range])
                }
            }
        } catch {
            print("Invalid regex: \(error)")
        }
        
        return nil
    }
    
    func removeIngredientExtraInformation(from text: String) -> String? {
        let pattern = #/\((.*?)\)|(\s*\d*\s*%)|(\s*\d*.\d*\s*%)|\[(.*?)\]|(\s*\d*\~\d*)|\[|\]?/#
        
        return text.replacing(pattern) { match in
            return ""
        }
    }
}
