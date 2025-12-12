//
//  AuthService.swift
//  SmartHealth
//
//  Updated for Firebase Auth + Solid Backend integration
//

import Foundation
import Combine
// import FirebaseAuthclass AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var currentUser: User?
    @Published var authToken: String?
    @Published var isAuthenticated: Bool = false
    
    private let tokenKey = "authToken"
    private let userKey = "currentUser"
    
    private init() {
        loadToken()
        loadUser()
        
        // Firebase Auth state observer
        _ = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            if firebaseUser == nil {
                self?.logout()
            }
        }
    }
    
    // MARK: - Register with Firebase + Solid
    func register(email: String, password: String, name: String?) async throws -> User {
        // 1. Create user in Firebase Auth
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        // 2. Get Firebase ID Token
        let firebaseToken = try await authResult.user.getIDToken()
        
        // 3. Sync with Solid backend
        let body: [String: Any] = [
            "firebaseUID": authResult.user.uid,
            "email": email,
            "name": name ?? ""
        ]
        
        let response: RegisterResponse = try await NetworkManager.shared.request(
            endpoint: "/api/auth/sync-firebase",
            method: .post,
            body: body,
            token: firebaseToken
        )
        
        // 4. Save locally
        self.authToken = firebaseToken
        self.currentUser = response.user
        self.isAuthenticated = true
        
        saveToken(firebaseToken)
        saveUser(response.user)
        
        return response.user
    }
    
    // MARK: - Login with Firebase + Solid
    func login(email: String, password: String) async throws -> User {
        // 1. Authenticate with Firebase
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        // 2. Get Firebase ID Token
        let firebaseToken = try await authResult.user.getIDToken()
        
        // 3. Get user profile from Solid
        let user: User = try await NetworkManager.shared.request(
            endpoint: "/api/auth/profile",
            method: .get,
            token: firebaseToken
        )
        
        // 4. Save locally
        self.authToken = firebaseToken
        self.currentUser = user
        self.isAuthenticated = true
        
        saveToken(firebaseToken)
        saveUser(user)
        
        return user
    }
    
    // MARK: - Logout
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
        
        self.authToken = nil
        self.currentUser = nil
        self.isAuthenticated = false
        
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
    }
    
    // MARK: - Get Current User Profile
    func getCurrentUser() async throws -> User {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw NetworkError.unauthorized
        }
        
        let firebaseToken = try await firebaseUser.getIDToken(forcingRefresh: true)
        
        let user: User = try await NetworkManager.shared.request(
            endpoint: "/api/auth/profile",
            method: .get,
            token: firebaseToken
        )
        
        self.currentUser = user
        self.authToken = firebaseToken
        saveToken(firebaseToken)
        saveUser(user)
        
        return user
    }
    
    // MARK: - Update Profile
    func updateProfile(name: String?, email: String?) async throws -> User {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw NetworkError.unauthorized
        }
        
        let firebaseToken = try await firebaseUser.getIDToken()
        
        let body: [String: Any] = [
            "name": name ?? "",
            "email": email ?? ""
        ]
        
        let user: User = try await NetworkManager.shared.request(
            endpoint: "/api/auth/profile",
            method: .patch,
            body: body,
            token: firebaseToken
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
        return Auth.auth().currentUser != nil && currentUser != nil
    }
}
