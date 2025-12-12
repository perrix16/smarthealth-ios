//
//  SolidAuthService.swift
//  SmartHealth
//
//  Created by Salvatore on 12/12/2025.
//  Authentication service for Solid Backend
//

import Foundation

/// Input for login
struct LoginInput: Codable {
    let email: String
    let password: String
}

/// Input for registration
struct RegisterInput: Codable {
    let email: String
    let password: String
    let name: String?
}

/// Response from auth endpoints
struct AuthResponse: Codable {
    let token: String
    let user: SolidUser
}

/// Authentication service for Solid backend
final class SolidAuthService {
    static let shared = SolidAuthService()
    private init() {}
    
    /// Login with email and password
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    /// - Returns: Auth response with token and user info
    func login(email: String, password: String) async throws -> AuthResponse {
        let input = LoginInput(email: email, password: password)
        let response: AuthResponse = try await TRPCClient.shared.call(
            procedure: "auth.login",
            input: input
        )
        
        // Save token
        TRPCClient.shared.setAuthToken(response.token)
        
        return response
    }
    
    /// Register a new user
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - name: User name (optional)
    /// - Returns: Auth response with token and user info
    func register(email: String, password: String, name: String? = nil) async throws -> AuthResponse {
        let input = RegisterInput(email: email, password: password, name: name)
        let response: AuthResponse = try await TRPCClient.shared.call(
            procedure: "auth.register",
            input: input
        )
        
        // Save token
        TRPCClient.shared.setAuthToken(response.token)
        
        return response
    }
    
    /// Logout the current user
    func logout() {
        TRPCClient.shared.clearAuthToken()
    }
    
    /// Check if user is logged in
    var isLoggedIn: Bool {
        return TRPCClient.shared.isAuthenticated
    }
}
