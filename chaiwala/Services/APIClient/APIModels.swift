//
//  APIModels.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/6/25.
//

import Foundation

struct BackendError: Codable, Error {
    let message: String
    let requestId: String
    let context: String?
}

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case backend(BackendError)
    case unexpectedStatusCode(Int, Data)
    case network(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid. Please check the request URL and try again."
            
        case .decodingError:
            return "There was an error decoding the response data. Please try again later."
            
        case .backend(let backendError):
            return backendError.message  // Assuming BackendError has a localizedDescription
            
        case .unexpectedStatusCode(let statusCode, let data):
            let responseString = String(data: data, encoding: .utf8) ?? "No response data"
            return "Received an unexpected status code \(statusCode). Response: \(responseString)"
            
        case .network(let networkError):
            return "A network error occurred: \(networkError.localizedDescription)"
        }
    }
}


struct UploadResponse: Codable {
    let FileId: String
    let Message: String
}
