//
//  APIClient.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

import Foundation
import Alamofire

/// Klien HTTP berbasis Alamofire untuk request generik.
/// Menangani header `X-User-ID` dan decoding respons otomatis.
class HttpClient {
    static let shared = HttpClient()
    private init() {}

    func request<P: Encodable, T: Decodable>(
            url: String,
            method: HTTPMethod = .get,
            parameters: P? = nil,
            includeUserHeader: Bool = true,
            extraHeaders: HTTPHeaders? = nil,
            completion: @escaping (Result<T, NetworkError>) -> Void
        ) {
            
            var alamofireParameters: Parameters? = nil
            
           
            if let params = parameters {
                do {
                    let data = try JSONEncoder().encode(params)
                    alamofireParameters = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Parameters
                } catch {
                    
                    completion(.failure(.decodingError(error)))
                    return
                }
            }
            
            var headers = extraHeaders ?? HTTPHeaders()
            headers.add(name: "Content-Type", value: "application/json")

            if includeUserHeader,
               let userId = UserDefaults.standard.string(forKey: "userId"),
               !userId.isEmpty {
                headers.add(name: "X-User-ID", value: userId)
            }

            #if DEBUG
            let methodName = method.rawValue
            if includeUserHeader {
                let xuid = UserDefaults.standard.string(forKey: "userId") ?? ""
                print("[HTTP] \(methodName) \(url) X-User-ID=\(xuid)")
            } else {
                print("[HTTP] \(methodName) \(url)")
            }
            #endif

            AF.request(url,
                       method: method,
                       parameters: alamofireParameters,
                       encoding: JSONEncoding.default,
                       headers: headers)
                .validate()
                // Perform decoding off the main queue to avoid UI stalls
                .responseDecodable(of: T.self, queue: .global(qos: .utility)) { response in
                    switch response.result {
                    case .success(let value):
                        completion(.success(value))
                    case .failure(let afError):
                        // Handle no internet connection
                        if let urlError = afError.underlyingError as? URLError,
                           urlError.code == .notConnectedToInternet || 
                           urlError.code == .networkConnectionLost ||
                           urlError.code == .dataNotAllowed {
                            completion(.failure(.noInternetConnection))
                            return
                        }
                        
                        // Handle HTTP 500 server errors
                        if let statusCode = response.response?.statusCode, statusCode >= 500 {
                            completion(.failure(.serverError))
                            return
                        }
                        
                        if (response.response?.statusCode == 400), let data = response.data {
                            do {
                                let envelope = try JSONDecoder().decode(ApiResponseDTO<EmptyDTO>.self, from: data)
                                if let msg = envelope.message, !msg.isEmpty {
                                    completion(.failure(.custom(msg)))
                                    return
                                }
                            } catch {
                            }
                        }
                        if let decodingError = afError.underlyingError as? DecodingError {
                            completion(.failure(.decodingError(decodingError)))
                        } else {
                            completion(.failure(.afError(afError)))
                        }
                    }
                }
        }
}
