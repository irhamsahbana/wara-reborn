//
//  AlternativeProductsDTO.swift
//  Wara
//
//  Created by Meow on 10/11/25
//

import Foundation

/// DTO item untuk produk alternatif sesuai respons backend.
/// Memuat informasi dasar produk beserta status KMF dan gambar.
struct AlternativeProductItemDTO: Decodable, Identifiable {
    let id: String
    let isKmf: Bool
    let englishCategory: String
    let koreanCategory: String
    let englishName: String
    let frontCoverURL: String?
    let backCoverURL: String?
    let favoriteCounter: Int

    enum CodingKeys: String, CodingKey {
        case id
        case isKmf = "is_kmf"
        case englishCategory = "english_category"
        case koreanCategory = "korean_category"
        case englishName = "english_name"
        case frontCoverURL = "front_cover_url"
        case backCoverURL = "back_cover_url"
        case favoriteCounter = "favorite_counter"
    }
}

/// Payload untuk daftar produk alternatif dalam amplop `ApiResponseDTO`.
struct AlternativeProductsPayloadDTO: Decodable {
    let items: [AlternativeProductItemDTO]
}