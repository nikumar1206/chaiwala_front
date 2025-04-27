//
//  AuthModels.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/6/25.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct RefreshRequest: Codable {
    let refreshToken: String
}

// Define the GeneratedJWTResponse struct that corresponds to the Go struct
struct Token: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int64
    let tokenType: String
}

// Define the User struct that corresponds to the Go `User` struct
struct User: Codable {
    let id: Int32
    let username: String
    let email: String
    let bio: String
    let avatarUrl: String
    let createdAt: String // pgtype.Timestamp can be represented as a String or Date in Swift
}

// Define the AuthResponse struct that matches Go's `LoginUserResponse`
struct AuthResponse: Codable {
    let user: User
    let token: Token
}



enum AuthError: Error {
    case invalidResponse, serverError(String)
}
