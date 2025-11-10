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
}