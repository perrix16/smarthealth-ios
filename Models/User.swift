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
        let firebaseUID: String?
    let email: String
    let name: String?
    let createdAt: Date?
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        case id
                case firebaseUID = "firebase_uid"
        case email
        case name
        case createdAt = "created_at"
        case token
    }
}


// MARK: - User Profile Update
struct UserProfileUpdate: Codable {
    let name: String?
    let email: String?
}
