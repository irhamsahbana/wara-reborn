//
//  ScanRemoteSource.swift
//  Wara
//
//  Created by Meow on 09/11/25
//

import Foundation
import Alamofire

/// Sumber data remote untuk melakukan pemindaian produk.
/// Mengirim teks OCR mentah ke endpoint `POST /products/scan`.
class ScanRemoteSource {
    static let shared = ScanRemoteSource()
    private init() {}

    private let httpClient = HttpClient.shared

    private var baseURL: String { Env.apiBaseURL }

    /// Memanggil scan API; mengembalikan payload hasil scan.
    /// Menggunakan endpoint versi terbaru yang mendukung `product_candidates` dan `label`.
    func scanProduct(rawOCRText: String, completion: @escaping (Result<ScanDataDTO, NetworkError>) -> Void) {
        let url = "\(baseURL)/products/scan/v2"
        // Backend requires UUIDv7 for request id; use local generator
        let payload = ScanRequestDTO(id: UUIDv7.generate(), rawOCRText: rawOCRText)

        httpClient.request(url: url,
                           method: .post,
                           parameters: payload,
                           includeUserHeader: true,
                           completion: { (result: Result<ApiResponseDTO<ScanDataDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if let data = envelope.data {
                    completion(.success(data))
                } else {
                    completion(.failure(.custom(envelope.message ?? "Empty payload")))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }

    func scanProduct(id: String, rawOCRText: String, completion: @escaping (Result<ScanDataDTO, NetworkError>) -> Void) {
        let url = "\(baseURL)/products/scan/v2"
        let payload = ScanRequestDTO(id: id, rawOCRText: rawOCRText)

        httpClient.request(url: url,
                           method: .post,
                           parameters: payload,
                           includeUserHeader: true,
                           completion: { (result: Result<ApiResponseDTO<ScanDataDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if let data = envelope.data {
                    completion(.success(data))
                } else {
                    completion(.failure(.custom(envelope.message ?? "Empty payload")))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }
}
