//
//  TRPCClient.swift
//  SmartHealth
//
//  Created by Salvatore on 12/12/2025.
//  tRPC Client for Solid Backend
//

import Foundation

/// Client for making tRPC calls to the Solid backend
final class TRPCClient {
    static let shared = TRPCClient()
    private init() {}
    
    private var authToken: String?
    
    /// Set the authentication token
    func setAuthToken(_ token: String) {
        self.authToken = token
        UserDefaults.standard.set(token, forKey: "solidAuthToken")
    }
    
    /// Clear the authentication token
    func clearAuthToken() {
        self.authToken = nil
        UserDefaults.standard.removeObject(forKey: "solidAuthToken")
    }
    
    /// Load saved authentication token
    func loadAuthToken() {
        self.authToken = UserDefaults.standard.string(forKey: "solidAuthToken")
    }
    
    /// Check if user is authenticated
    var isAuthenticated: Bool {
        return authToken != nil
    }
    
    /// Make a tRPC call
    /// - Parameters:
    ///   - procedure: The tRPC procedure name (e.g., "auth.login")
    ///   - input: The input parameters
    /// - Returns: The decoded response
    func call<Input: Encodable, Output: Decodable>(
        procedure: String,
        input: Input
    ) async throws -> Output {
        // Build URL: /trpc/auth.login?input={"0":{...}}
        var components = URLComponents(url: SolidAPIConfig.baseURL, resolvingAgainstBaseURL: false)!
        components.path = "\(SolidAPIConfig.trpcPath)/\(procedure)"
        
        // tRPC expects input in format: {"0": actualInput}
        let wrappedInput = ["0": input]
        let inputData = try JSONEncoder().encode(wrappedInput)
        let inputString = String(data: inputData, encoding: .utf8)!
        components.queryItems = [URLQueryItem(name: "input", value: inputString)]
        
        guard let url = components.url else {
            throw TRPCError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token if available
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TRPCError.badResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw TRPCError.serverError(statusCode: httpResponse.statusCode)
        }
        
        // tRPC response format: {"result": {"data": ...}}
        struct TRPCResponse<T: Decodable>: Decodable {
            struct Result: Decodable {
                let data: T
            }
            let result: Result
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let trpcResponse = try decoder.decode(TRPCResponse<Output>.self, from: data)
        return trpcResponse.result.data
    }
}

/// tRPC-specific errors
enum TRPCError: LocalizedError {
    case invalidURL
    case badResponse
    case serverError(statusCode: Int)
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .badResponse:
            return "Bad response from server"
        case .serverError(let code):
            return "Server error (\(code))"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}
