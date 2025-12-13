//
//  AuthService.swift
//  SmartHealth
//
//  Updated for TrySolid Backend integration
//

import Foundation
import Combine


// Response models for API
struct LoginResponse: Codable {
    let token: String
    let user: User
}

struct SignupResponse: Codable {
    let token: String
    let user: User
}

class AuthService: ObservableObject {

static let shared = AuthService()

@Published var currentUser: User?
@Published var authToken: String?
@Published var isAuthenticated: Bool = false

private let tokenKey = "authToken"
private let userKey = "currentUser"
private let networkManager = NetworkManager.shared

private init() {
    loadToken()
    loadUser()
}

func signIn(email: String, password: String) async throws {
    
    
    
    let response: LoginResponse = try await networkManager.request(
        endpoint: "/api/auth/login",
        method: .post,
                body: ["email": email, "password": password])
    
    authToken = response.token
    currentUser = response.user
    isAuthenticated = true
    
    saveToken(response.token)
    saveUser(response.user)
}

func signUp(email: String, password: String, name: String) async throws {
    
    
    
    let response: SignupResponse = try await networkManager.request(
        endpoint: "/api/auth/register",
        method: .post,
                body: ["email": email, "password": password, "name": name])
    
    authToken = response.token
    currentUser = response.user
    isAuthenticated = true
    
    saveToken(response.token)
    saveUser(response.user)
}

func signOut() {
    authToken = nil
    currentUser = nil
    isAuthenticated = false
    
    UserDefaults.standard.removeObject(forKey: tokenKey)
    UserDefaults.standard.removeObject(forKey: userKey)
}

private func loadToken() {
    if let token = UserDefaults.standard.string(forKey: tokenKey) {
        authToken = token
        isAuthenticated = true
    }
}

private func loadUser() {
    if let userData = UserDefaults.standard.data(forKey: userKey),
       let user = try? JSONDecoder().decode(User.self, from: userData) {
        currentUser = user
    }
}

private func saveToken(_ token: String) {
    UserDefaults.standard.set(token, forKey: tokenKey)
}

private func saveUser(_ user: User) {
    if let encoded = try? JSONEncoder().encode(user) {
        UserDefaults.standard.set(encoded, forKey: userKey)
    }
}
}
