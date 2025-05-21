//
//  AuthService.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/6/25.
//
import Foundation

class AuthService {
    static let shared = AuthService()
    
    func login(email: String, password: String) async -> Result<AuthResponse, NetworkError> {
        let req = LoginRequest(email: email, password: password)
        
        let res: Result<AuthResponse, NetworkError> = await APIClient.shared.request(
            method: "POST",
            path: "/auth/login",
            body: req
        )
        
        return res.flatMap { authResponse in
            do {
                try KeychainHelper.shared.set(authResponse.token.accessToken, forKey: "accessToken")
                try KeychainHelper.shared.set(authResponse.token.refreshToken, forKey: "refreshToken")
                return .success(authResponse)
            } catch let err {
                print("Error saving token to keychain: \(err)")
                return .success(authResponse)
            }
        }
    }


    func register(email: String, password: String) async -> Result<AuthResponse, NetworkError> {
        let req = RegisterRequest(email: email, password: password)
        let res: Result<AuthResponse, NetworkError> = await APIClient.shared.request(
            method: "POST",
            path: "/auth/register",
            body: req
        )
        
        return res.flatMap { authResponse in
            do {
                try KeychainHelper.shared.set(authResponse.token.accessToken, forKey: "accessToken")
                try KeychainHelper.shared.set(authResponse.token.refreshToken, forKey: "refreshToken")
                return .success(authResponse)
            } catch {
                print("Error saving token to keychain: \(error)")
                return .success(authResponse)
            }
        }
    }

    func getRefreshToken(t: String) async -> Result<Token, NetworkError> {
        // todo: if not present or expired, we actually need to go back to login page.
        print("requesting new refresh token \(t)")
        let res: Result<Token, NetworkError> = await APIClient.shared.request(
            method: "POST",
            path: "/auth/refresh",
            headers: ["Authorization":"Bearer \(t)"]
        )
        
        return res.flatMap { authResponse in
            do {
                try KeychainHelper.shared.set(authResponse.accessToken, forKey: "accessToken")
                try KeychainHelper.shared.set(authResponse.refreshToken, forKey: "refreshToken")
                return .success(authResponse)
            } catch {
                print("Error saving token to keychain: \(error)")
                return .success(authResponse)
            }
        }
    }

    func getToken() throws -> String {
        
        let tokenStr = KeychainHelper.shared.get(forKey: "accessToken") ?? ""
        print("what is tokenStr here \n \(tokenStr)")
        return tokenStr
    }
    
    func getFreshAuthToken() async -> String? {
        var accessToken = validateKeyChainToken(key: "accessToken")
        
        if accessToken != nil {
            print("fresh token is access")
            return accessToken
        }
        
        print("invalid token, need to fallback to refresh token")
        let refreshToken = validateKeyChainToken(key: "refreshToken")
        
        if refreshToken == nil {
            print("refreshToken also invalid, damn")
            return nil
        }
        
        // access token nil, but refresh token is not
        let res = await self.getRefreshToken(t: refreshToken!)
        print("res here \n \(res)")
        
        switch res {
        case .success(let token):
            // must always return accessToken
            return validateKeyChainToken(key: "accessToken")
        case .failure(let err ):
            print("failed to get new token from refresh token: \(err)")
            return nil
        }

    }
    
    func constructHeaders() async ->   [String: String] {
        var headers: [String: String] = [:]
        guard let token = await getFreshAuthToken() else {
            print("Auth error occurred, redirecting to login.")
            AuthManager.shared.logoutAndRedirectToLogin()
            return [:]
        }
        headers["Authorization"] = "Bearer \(token)"
        return headers
    }

    // return token from keychain if valid
    func validateKeyChainToken(key: String) -> String? {
        guard let accessToken = KeychainHelper.shared.get(forKey: key) else {
            return nil
        }
        
        let segments = accessToken.split(separator: ".")
        guard segments.count == 3 else {
            return nil
        }
        
        let payloadSegment = segments[1]
        
        let base64 = String(payloadSegment)
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        
        guard let payloadData = Data(base64Encoded: base64) else {
            return nil
        }
        
        guard let payloadJson = try? JSONSerialization.jsonObject(with: payloadData, options: []),
              let payloadDict = payloadJson as? [String: Any] else {
            return nil
        }
        
        guard let exp = payloadDict["exp"] as? TimeInterval else {
            return nil
        }
        
        let expirationDate = Date(timeIntervalSince1970: exp)
        let bufferDate = expirationDate.addingTimeInterval(-5 * 60)
        if bufferDate > Date() {
            return accessToken
        }
        return nil
        
    }
}
