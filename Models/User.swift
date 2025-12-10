//
//  User.swift
//  SmartHealth
//
//  Created by Salvatore on 10/12/2025.
//

import Foundation

// MARK: - User Model
struct User: Codable, Identifiable {
    let id: String
    let email: String
    let name: String?
    let createdAt: Date?
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case createdAt = "created_at"
        case token
    }
}

// MARK: - Login Request
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Login Response
struct LoginResponse: Codable {
    let token: String
    let user: User
}

// MARK: - Register Request
struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String?
}

// MARK: - Register Response
struct RegisterResponse: Codable {
    let token: String
    let user: User
    let message: String?
}

// MARK: - User Profile Update
struct UserProfileUpdate: Codable {
    let name: String?
    let email: String?
}
