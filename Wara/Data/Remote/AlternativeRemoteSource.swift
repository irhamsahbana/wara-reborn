//
//  AlternativeRemoteSource.swift
//  Wara
//
//  Created by Meow on 10/11/25
//

import Foundation

/// Sumber data remote untuk mengambil produk alternatif berdasarkan kategori.
/// Memanggil endpoint `GET /products/alternatives?category=...&paginate=...`.
final class AlternativeRemoteSource {
    static let shared = AlternativeRemoteSource()
    private init() {}

    private let httpClient = HttpClient.shared

    private var baseURL: String { Env.apiBaseURL }

    /// Mengambil alternatif produk berdasarkan `category`.
    /// - Parameters:
    ///   - category: Nama kategori (lebih baik gunakan Korea jika tersedia).
    ///   - paginate: Jumlah item per halaman (default 5).
    ///   - completion: Callback dengan daftar item atau error jaringan.
    func fetchAlternatives(category: String, paginate: Int = 5, completion: @escaping (Result<[AlternativeProductItemDTO], NetworkError>) -> Void) {
        var url = "\(baseURL)/products/alternatives"
        let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
        url += "?category=\(encodedCategory)&paginate=\(paginate)"

        httpClient.request(url: url,
                           method: .get,
                           parameters: nil as String?,
                           includeUserHeader: true,
                           completion: { (result: Result<ApiResponseDTO<AlternativeProductsPayloadDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if let payload = envelope.data {
                    completion(.success(payload.items))
                } else {
                    completion(.failure(.custom(envelope.message ?? "Empty payload")))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }

    func fetchAlternativeDetail(id: String, category: String, completion: @escaping (Result<AlternativeProductItemDTO, NetworkError>) -> Void) {
        let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
        let encodedId = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? id
        let url = "\(baseURL)/products/alternatives/\(encodedId)?category=\(encodedCategory)"

        httpClient.request(url: url,
                           method: .get,
                           parameters: nil as String?,
                           includeUserHeader: true,
                           completion: { (result: Result<ApiResponseDTO<AlternativeProductDetailDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if let detail = envelope.data {
                    let item = AlternativeProductItemDTO(
                        id: id,
                        isKmf: detail.isKmf ?? (category.lowercased() == "kmf"),
                        isFavorited: false,
                        englishCategory: detail.englishProductCategory ?? "",
                        koreanCategory: detail.koreanProductCategory ?? "",
                        englishName: detail.englishName ?? "",
                        frontCoverURL: detail.frontCoverURL,
                        backCoverURL: detail.backCoverURL,
                        favoriteCounter: 0
                    )
                    completion(.success(item))
                } else {
                    self.httpClient.request(url: url,
                                             method: .get,
                                             parameters: nil as String?,
                                             includeUserHeader: true,
                                             completion: { (altResult: Result<ApiResponseDTO<ScanDataDTO>, NetworkError>) in
                        switch altResult {
                        case .success(let env2):
                            if let data = env2.data {
                                let item = AlternativeProductItemDTO(
                                    id: id,
                                    isKmf: data.isKmf,
                                    isFavorited: false,
                                    englishCategory: data.englishProductCategory ?? "",
                                    koreanCategory: data.koreanProductCategory ?? "",
                                    englishName: data.englishName,
                                    frontCoverURL: data.frontCoverURL,
                                    backCoverURL: data.backCoverURL,
                                    favoriteCounter: 0
                                )
                                completion(.success(item))
                            } else {
                                completion(.failure(.custom(env2.message ?? "Empty payload")))
                            }
                        case .failure(let e):
                            completion(.failure(e))
                        }
                    })
                }
            case .failure:
                self.httpClient.request(url: url,
                                        method: .get,
                                        parameters: nil as String?,
                                        includeUserHeader: true,
                                        completion: { (altResult: Result<ApiResponseDTO<ScanDataDTO>, NetworkError>) in
                    switch altResult {
                    case .success(let env2):
                        if let data = env2.data {
                            let item = AlternativeProductItemDTO(
                                id: id,
                                isKmf: data.isKmf,
                                isFavorited: false,
                                englishCategory: data.englishProductCategory ?? "",
                                koreanCategory: data.koreanProductCategory ?? "",
                                englishName: data.englishName,
                                frontCoverURL: data.frontCoverURL,
                                backCoverURL: data.backCoverURL,
                                favoriteCounter: 0
                            )
                            completion(.success(item))
                        } else {
                            completion(.failure(.custom(env2.message ?? "Empty payload")))
                        }
                    case .failure(let e):
                        completion(.failure(e))
                    }
                })
            }
        })
    }

    func fetchAlternativeDetailData(id: String, category: String, completion: @escaping (Result<AlternativeProductDetailDTO, NetworkError>) -> Void) {
        let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
        let encodedId = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? id
        let url = "\(baseURL)/products/alternatives/\(encodedId)?category=\(encodedCategory)"

        httpClient.request(url: url,
                           method: .get,
                           parameters: nil as String?,
                           includeUserHeader: true,
                           completion: { (result: Result<ApiResponseDTO<AlternativeProductDetailDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if let detail = envelope.data {
                    completion(.success(detail))
                } else {
                    self.httpClient.request(url: url,
                                            method: .get,
                                            parameters: nil as String?,
                                            includeUserHeader: true,
                                            completion: { (altResult: Result<ApiResponseDTO<ScanDataDTO>, NetworkError>) in
                        switch altResult {
                        case .success(let env2):
                            if let data = env2.data {
                                let detail = AlternativeProductDetailDTO(
                                    label: data.label,
                                    status: data.status,
                                    statusMessage: data.statusMessage,
                                    englishName: data.englishName,
                                    koreanName: data.koreanName,
                                    koreanPronunciation: data.koreanPronunciation,
                                    englishProducent: data.englishProducent,
                                    koreanProducent: data.koreanProducent,
                                    englishProductCategory: data.englishProductCategory,
                                    koreanProductCategory: data.koreanProductCategory,
                                    koreanProductCategoryPronunciation: data.koreanProductCategoryPronunciation,
                                    frontCoverURL: data.frontCoverURL,
                                    backCoverURL: data.backCoverURL,
                                    englishIngredients: data.englishIngredients,
                                    englishFacilityInfo: data.englishFacilityInfo,
                                    isFromDb: data.isFromDb,
                                    isKmf: data.isKmf,
                                    certificateNo: data.certificateNo,
                                    certificateValid: data.certificateValid,
                                    productCandidates: data.productCandidates,
                                    ingridients: data.ingridients,
                                    listedIngridients: data.listedIngridients,
                                    notListedIngridients: data.notListedIngridients,
                                    facility: data.facility
                                )
                                completion(.success(detail))
                            } else {
                                completion(.failure(.custom(env2.message ?? "Empty payload")))
                            }
                        case .failure(let e):
                            completion(.failure(e))
                        }
                    })
                }
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }

    func toggleFavorite(id: String, favoritableType: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let url = "\(baseURL)/products/favorites"
        let payload = FavoriteRequestDTO(id: id, favoritableType: favoritableType)
        httpClient.request(url: url,
                           method: .post,
                           parameters: payload,
                           includeUserHeader: true,
                           completion: { (result: Result<ApiResponseDTO<FavoriteResponseDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if envelope.success == false {
                    completion(.failure(.custom(envelope.message ?? "Unknown error")))
                } else if let data = envelope.data {
                    completion(.success(data.isFavorited))
                } else {
                    completion(.failure(.custom(envelope.message ?? "Empty payload")))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }
}
