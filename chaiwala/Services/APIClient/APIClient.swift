//
//  APIClient.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/6/25.
//
import Foundation
import SwiftUI

class APIClient {
    static let shared = APIClient()
    static let host = ProcessInfo.processInfo.environment["HOST"] ?? ""
    private init() {}

    func request<T: Decodable, U: Encodable>(
        method: String,
        path: String,
        body: U? = nil,
        headers: [String: String] = ["Content-Type": "application/json"]
    ) async -> Result<T, NetworkError> {
        guard let url = URL(string: "\(APIClient.host)\(path)") else {
            return .failure(.invalidURL)
        }

        print("request: \(method) \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return .failure(.network(error))
            }
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unexpectedStatusCode(-1, data))
            }

            if (200..<300).contains(httpResponse.statusCode) {
                do {
                    print("successful request, num bytes:", data)
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    return .success(decoded)
                } catch {
                    return .failure(.decodingError)
                }
            } else {
                do {
                    let backendError = try JSONDecoder().decode(BackendError.self, from: data)
                    print("did we get backend error")
                    return .failure(.backend(backendError))
                } catch let error {
                    print("hit catch block", error)
                    return .failure(.unexpectedStatusCode(httpResponse.statusCode, data))
                }
            }
        } catch {
            return .failure(.network(error))
        }
    }
    func request<T: Decodable>(
        method: String,
        path: String,
        headers: [String: String] = ["Content-Type": "application/json"]
    ) async -> Result<T, NetworkError> {
        return await request(
            method: method, path: path, body: Optional<Data>.none, headers: headers)
    }

    func requestImage(
        path: String,
        headers: [String: String] = [:]
    ) async -> Result<UIImage, NetworkError> {
        guard let url = URL(string: "\(APIClient.host)\(path)") else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unexpectedStatusCode(-1, data))
            }

            if (200..<300).contains(httpResponse.statusCode) {
                if let image = UIImage(data: data) {
                    return .success(image)
                } else {
                    return .failure(.decodingError)  // or maybe a .invalidImageData if you want a more specific case
                }
            } else {
                do {
                    let backendError = try JSONDecoder().decode(BackendError.self, from: data)
                    return .failure(.backend(backendError))
                } catch {
                    return .failure(.unexpectedStatusCode(httpResponse.statusCode, data))
                }
            }
        } catch {
            return .failure(.network(error))
        }
    }

    func uploadFile(
        path: String,
        fileData: Data,
    ) async -> Result<UploadResponse, NetworkError> {
        guard let url = URL(string: "\(APIClient.host)\(path)") else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        let accessToken = KeychainHelper.shared.get(forKey: "accessToken")!

        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue(
            "multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let mimeType = guessMimeType(for: fileData)
        print("guessed mimetype \(mimeType)")

        // Form data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append(
            "Content-Disposition: form-data; name=\"file\"; filename=\"\("file")\"\r\n".data(
                using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)

        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unexpectedStatusCode(-1, data))
            }

            if (200..<300).contains(httpResponse.statusCode) {
                let uploadResponse = try JSONDecoder().decode(UploadResponse.self, from: data)
                return .success(uploadResponse)
            } else {
                let backendError = try? JSONDecoder().decode(BackendError.self, from: data)
                return .failure(
                    backendError.map { .backend($0) }
                        ?? .unexpectedStatusCode(httpResponse.statusCode, data))
            }
        } catch {
            return .failure(.network(error))
        }
    }
}

func guessMimeType(for data: Data) -> String {
    var buffer = [UInt8](repeating: 0, count: 1)
    data.copyBytes(to: &buffer, count: 1)

    switch buffer[0] {
    case 0xFF:
        return "image/jpeg"
    case 0x89:
        return "image/png"
    case 0x47:
        return "image/gif"
    case 0x49, 0x4D:
        return "image/tiff"
    case 0x00:
        if data.count >= 12,
            let str = String(bytes: data[8..<12], encoding: .ascii),
            str == "HEIC"
        {
            return "image/heic"
        }
        return "application/octet-stream"
    default:
        return "application/octet-stream"
    }
}
