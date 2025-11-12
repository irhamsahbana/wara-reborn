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

    private var baseURL: String {
        let schemeRaw = (Bundle.main.object(forInfoDictionaryKey: "API_SCHEME") as? String) ?? ""
        let hostRaw = (Bundle.main.object(forInfoDictionaryKey: "API_HOST") as? String) ?? ""
        let scheme = schemeRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        let hostVal = hostRaw.trimmingCharacters(in: .whitespacesAndNewlines)
        precondition(!scheme.isEmpty, "API_SCHEME missing. Set via xcconfig and map to target configuration.")
        precondition(!hostVal.isEmpty, "API_HOST missing. Set via xcconfig and map to target configuration.")
        precondition(scheme == "http" || scheme == "https", "API_SCHEME must be 'http' or 'https'.")

        var host = hostVal
        var port: Int? = nil
        if let colonIndex = host.firstIndex(of: ":") {
            let hostname = String(host[..<colonIndex])
            let portStr = String(host[host.index(after: colonIndex)...])
            host = hostname
            if let p = Int(portStr) { port = p }
        }

        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        guard let url = components.url else {
            preconditionFailure("Invalid API_SCHEME/API_HOST combination.")
        }
        return url.absoluteString
    }

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
}