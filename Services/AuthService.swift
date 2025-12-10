//
//  AuthService.swift
//  SmartHealth
//
//  Created by Salvatore on 10/12/2025.
//

import Foundation
import Combine

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: User?
    @Published var authToken: String?
    @Published var isAuthenticated: Bool = false
    
    private let tokenKey = "authToken"
    private let userKey = "currentUser"
    
    private init() {
        loadToken()
        loadUser()
    }
    
    // MARK: - Login
    func login(email: String, password: String) async throws -> User {
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let response: LoginResponse = try await NetworkManager.shared.request(
            endpoint: "/api/auth/login",
            method: .post,
            body: body
        )
        
        // Save auth data
        self.authToken = response.token
        self.currentUser = response.user
        self.isAuthenticated = true
        
        saveToken(response.token)
        saveUser(response.user)
        
        return response.user
    }
    
    // MARK: - Register
    func register(email: String, password: String, name: String?) async throws -> User {
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "name": name ?? ""
        ]
        
        let response: RegisterResponse = try await NetworkManager.shared.request(
            endpoint: "/api/auth/register",
            method: .post,
            body: body
        )
        
        // Save auth data
        self.authToken = response.token
        self.currentUser = response.user
        self.isAuthenticated = true
        
        saveToken(response.token)
        saveUser(response.user)
        
        return response.user
    }
    
    // MARK: - Logout
    func logout() {
        self.authToken = nil
        self.currentUser = nil
        self.isAuthenticated = false
        
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    // MARK: - Get Current User Profile
    func getCurrentUser() async throws -> User {
        guard let token = authToken else {
            throw NetworkError.unauthorized
        }
        
        let user: User = try await NetworkManager.shared.request(
            endpoint: "/api/auth/profile",
            method: .get,
            token: token
        )
        
        self.currentUser = user
        saveUser(user)
        
        return user
    }
    
    // MARK: - Update Profile
    func updateProfile(name: String?, email: String?) async throws -> User {
        guard let token = authToken else {
            throw NetworkError.unauthorized
        }
        
        let body: [String: Any] = [
            "name": name ?? "",
            "email": email ?? ""
        ]
        
        let user: User = try await NetworkManager.shared.request(
            endpoint: "/api/auth/profile",
            method: .patch,
            body: body,
            token: token
        )
        
        self.currentUser = user
        saveUser(user)
        
        return user
    }
    
    // MARK: - Token Management
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    private func loadToken() {
        if let token = UserDefaults.standard.string(forKey: tokenKey) {
            self.authToken = token
            self.isAuthenticated = true
        }
    }
    
    // MARK: - User Management
    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    private func loadUser() {
        if let data = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            self.currentUser = user
        }
    }
    
    // MARK: - Check Authentication
    func checkAuth() -> Bool {
        return authToken != nil && currentUser != nil
    }
}
