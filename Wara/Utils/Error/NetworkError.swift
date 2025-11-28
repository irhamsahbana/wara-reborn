//
//  APIError.swift
//  Wara
//
//  Created by Meow on 21/10/25.
//

import Alamofire

enum NetworkError: Error {
    case invalidURL
    case afError(AFError)
    case decodingError(Error)
    case custom(String)
    case serverError
    case noInternetConnection
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "URL not valid."
        case .afError(let error):
            return "Error Alamofire: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Error Decoding: \(error.localizedDescription)"
        case .custom(let message):
            return message
        case .serverError:
            return "Oops! The server is busy right now.\nPlease try again later."
        case .noInternetConnection:
            return "Oops! No internet connection detected.\nPlease check your network and try again."
        }
    }
}
