//
//  ProductCandidateDTO.swift
//  Wara
//
//  Created by Meow on 12/11/25
//

import Foundation

struct ProductCandidateDTO: Decodable, Identifiable {
    let id: String?
    let englishName: String?
    let englishCategory: String?
    let koreanCategory: String?
    let frontCoverURL: String?
    let backCoverURL: String?
    let isKmf: Bool?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case englishName = "english_name"
        case englishCategory = "english_category"
        case koreanCategory = "korean_category"
        case frontCoverURL = "front_cover_url"
        case backCoverURL = "back_cover_url"
        case isKmf = "is_kmf"
        case status
    }
}