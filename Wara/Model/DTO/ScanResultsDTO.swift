//
//  ScanResultsDTO.swift
//  Wara
//
//  Created by Meow on 18/11/25
//

import Foundation

struct ScanResultsItemDTO: Decodable, Identifiable {
    let id: String
    let status: String
    let sourceCategory: String?
    let frontCoverURL: String?
    let backCoverURL: String?
    let englishName: String
    let englishProductCategory: String

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case sourceCategory = "category"
        case frontCoverURL = "front_cover_url"
        case backCoverURL = "back_cover_url"
        case englishName = "english_name"
        case englishProductCategory = "english_product_category"
    }
}

struct ScanResultsMetaDTO: Decodable {
    let page: Int
    let paginate: Int
    let totalData: Int
    let totalPage: Int

    enum CodingKeys: String, CodingKey {
        case page
        case paginate
        case totalData = "total_data"
        case totalPage = "total_page"
    }
}

struct ScanResultsPayloadDTO: Decodable {
    let items: [ScanResultsItemDTO]
    let meta: ScanResultsMetaDTO
}