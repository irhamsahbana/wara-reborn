//  Created by Meow on 14/11/25

import Foundation

struct AlternativeProductDetailDTO: Decodable {
    let label: String?
    let status: String?
    let statusMessage: String?
    let englishName: String?
    let koreanName: String?
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
    let isFromDb: Bool?
    let isKmf: Bool?
    let certificateNo: String?
    let certificateValid: String?
    let productCandidates: [ProductCandidateDTO]?
    let ingridients: [ScanIngredientDTO]?
    let listedIngridients: [ScanIngredientDTO]?
    let notListedIngridients: [ScanIngredientDTO]?
    let facility: ScanFacilityDTO?

    enum CodingKeys: String, CodingKey {
        case label
        case status
        case statusMessage = "status_message"
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
        case certificateNo = "certificate_no"
        case certificateValid = "certificate_valid"
        case productCandidates = "product_candidates"
        case ingridients
        case listedIngridients = "listed_ingridients"
        case notListedIngridients = "not_listed_ingridients"
        case facility
    }
}