//
//  CategoryRemoteSource.swift
//  Wara
//
//  Created by Meow on 24/10/25.
//

import Foundation
import Alamofire

/// Sumber data remote untuk operasi pengguna (create/fetch).
/// Menggunakan `HttpClient` dan membaca `API_SCHEME`/`API_HOST` dari Info.plist.
class UserRemoteSource {
    static let shared = UserRemoteSource()
    private init() {}

    private let httpClient = HttpClient.shared
    private var baseURL: String { Env.apiBaseURL }
    
    // Respons memakai ApiResponseDTO<T> dan EmptyDTO yang disatukan di Model/DTO

    /// Create user in backend. No X-User-ID header, only body { user_id }
    func createUser(payload: CreateUserRequestDTO, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let url = "\(baseURL)/users"
        httpClient.request(url: url,
                           method: .post,
                           parameters: payload,
                           includeUserHeader: false,
                           completion: { (result: Result<ApiResponseDTO<EmptyDTO>, NetworkError>) in
            switch result {
            case .success(let envelope):
                if envelope.success == false {
                    completion(.failure(.custom(envelope.message ?? "Unknown error")))
                } else {
                    completion(.success(()))
                }
            case .failure(let err):
                completion(.failure(err))
            }
        })
    }

    // Example-only: keep a fetch method using JSONPlaceholder to avoid breaking samples
    func fetchUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
        httpClient.request(url: url,
                           method: .get,
                           parameters: nil as String?,
                           completion: completion)
    }
}
