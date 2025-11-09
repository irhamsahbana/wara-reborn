//
//  ScanResponseDTO.swift
//  Wara
//
//  Created by Meow on 09/11/25
//

import Foundation

/// DTO untuk ingredient yang terdeteksi dari hasil scan.
struct ScanIngredientDTO: Decodable, Identifiable {
    let id: String?
    let rawText: String
    let koreanName: String
    let englishName: String
    let koreanPronunciation: String
    let isFoundInDb: Bool
    let category: String
    let englishDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case rawText = "raw_text"
        case koreanName = "korean_name"
        case englishName = "english_name"
        case koreanPronunciation = "korean_pronunciation"
        case isFoundInDb = "is_found_in_db"
        case category
        case englishDescription = "english_description"
    }
}

/// DTO untuk informasi fasilitas (facility) pada hasil scan.
struct ScanFacilityDTO: Decodable {
    let isInformed: Bool
    let isProduceWithHaramIngredients: Bool
    let rawText: String
    let englishDescription: String

    enum CodingKeys: String, CodingKey {
        case isInformed = "is_informed"
        case isProduceWithHaramIngredients = "is_produce_with_haram_ingredients"
        case rawText = "raw_text"
        case englishDescription = "english_description"
    }
}

/// Payload utama hasil scan dari backend.
struct ScanDataDTO: Decodable {
    let englishName: String
    let koreanName: String
    let koreanPronunciation: String?
    let englishProducent: String?
    let koreanProducent: String?
    let englishProductCategory: String?
    let koreanProductCategory: String?
    let koreanProductCategoryPronunciation: String?
    let frontCoverURL: String?
    let backCoverURL: String?
    let englishIngredients: String?
    let englishFacilityInfo: String?
    let isFromDb: Bool
    let isKmf: Bool
    let ingridients: [ScanIngredientDTO]
    let listedIngridients: [ScanIngredientDTO]
    let notListedIngridients: [ScanIngredientDTO]
    let facility: ScanFacilityDTO?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case koreanName = "korean_name"
        case koreanPronunciation = "korean_pronunciation"
        case englishProducent = "english_producent"
        case koreanProducent = "korean_producent"
        case englishProductCategory = "english_product_category"
        case koreanProductCategory = "korean_product_category"
        case koreanProductCategoryPronunciation = "korean_product_category_pronunciation"
        case frontCoverURL = "front_cover_url"
        case backCoverURL = "back_cover_url"
        case englishIngredients = "english_ingredients"
        case englishFacilityInfo = "english_facility_info"
        case isFromDb = "is_from_db"
        case isKmf = "is_kmf"
        case ingridients
        case listedIngridients = "listed_ingridients"
        case notListedIngridients = "not_listed_ingridients"
        case facility
    }
}