//
//  SolidAPIConfig.swift
//  SmartHealth
//
//  Created by Salvatore on 12/12/2025.
//  Configuration for Solid Backend Integration
//

import Foundation

/// Configuration for the Solid backend
enum SolidAPIConfig {
    /// Base URL for the Solid backend preview environment
    static let baseURL = URL(string: "https://preview-nskywevmbsy0ni9n9cj9oe.codapt.app")!
    
    /// Path for tRPC endpoints
    static let trpcPath = "/trpc"
    
    /// Production URL (update when published)
    // static let baseURL = URL(string: "https://your-production-url.codapt.app")!
}

/// Authentication token storage
struct AuthToken: Codable {
    let token: String
    let expiresAt: Date?
}

/// User model from Solid backend
struct SolidUser: Codable, Identifiable {
    let id: String
    let email: String
    let name: String?
    let createdAt: Date?
}
