//
//  ScanResultsRemoteSource.swift
//  Wara
//
//  Created by Meow on 18/11/25
//

import Foundation
import Alamofire

final class ScanResultsRemoteSource {
    static let shared = ScanResultsRemoteSource()
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

    func fetchScanResults(query: String?, page: Int, paginate: Int, completion: @escaping (Result<ScanResultsPayloadDTO, NetworkError>) -> Void) {
        var url = "\(baseURL)/products/scan-results"
        var queries: [String] = []
        if let q = query?.trimmingCharacters(in: .whitespacesAndNewlines), !q.isEmpty {
            let encoded = q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? q
            queries.append("q=\(encoded)")
        }
        queries.append("page=\(page)")
        queries.append("paginate=\(paginate)")
        if !queries.isEmpty {
            url += "?" + queries.joined(separator: "&")
        }

        httpClient.request(url: url,
                           method: .get,
                           parameters: nil as String?,
                           includeUserHeader: true,
                           completion: { (result: Result<ApiResponseDTO<ScanResultsPayloadDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if let payload = envelope.data {
                    completion(.success(payload))
                } else {
                    completion(.failure(.custom(envelope.message ?? "Empty payload")))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }

    func fetchScanResultDetail(id: String, completion: @escaping (Result<ScanDataDTO, NetworkError>) -> Void) {
        let encodedId = id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? id
        let url = "\(baseURL)/products/scan-results/\(encodedId)"
        httpClient.request(url: url,
                           method: .get,
                           parameters: nil as String?,
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

    func uploadScanPhoto(scanResultId: String, imageData: Data, fileName: String, packagingLabel: String, completion: @escaping (Result<UploadPhotoDTO, NetworkError>) -> Void) {
        let encodedId = scanResultId.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? scanResultId
        let url = "\(baseURL)/products/scan-results/\(encodedId)/upload-photo"

        var headers = HTTPHeaders()
        if let userId = UserDefaults.standard.string(forKey: "userId"), !userId.isEmpty {
            headers.add(name: "X-User-ID", value: userId)
        }

        let ext = (fileName as NSString).pathExtension.lowercased()
        let mimeType = (ext == "jpg" || ext == "jpeg") ? "image/jpeg" : "image/png"

        AF.upload(multipartFormData: { form in
            form.append(imageData, withName: "file", fileName: fileName, mimeType: mimeType)
            if let labelData = packagingLabel.data(using: .utf8) {
                form.append(labelData, withName: "packaging_label")
            }
        }, to: url, headers: headers)
        .validate()
        .responseDecodable(of: ApiResponseDTO<UploadPhotoDTO>.self, queue: .global(qos: .utility)) { response in
            switch response.result {
            case .success(let envelope):
                if let data = envelope.data {
                    completion(.success(data))
                } else {
                    completion(.failure(.custom(envelope.message ?? "Empty payload")))
                }
            case .failure(let afError):
                completion(.failure(.afError(afError)))
            }
        }
    }
}