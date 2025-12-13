//
// TRPCClient.swift
// SmartHealth
//
// Created by Salvatore on 10/12/2025.
// tRPC client for Solid Backend integration
//

import Foundation

/// tRPC Client for making RPC calls to Solid backend
class TRPCClient {
    static let shared = TRPCClient()
    
    private let networkManager = NetworkManager.shared
    
    private init() {}
    
    /// Call a tRPC procedure
    /// - Parameters:
    ///   - procedure: The procedure name (e.g., "glucoseReadings.list")
    ///   - input: The input data (encoded as JSON)
    /// - Returns: The decoded response
    func call<T: Decodable>(
        procedure: String,
        input: some Encodable
    ) async throws -> T {
        // tRPC uses POST requests to /api/trpc/{procedure}
        let endpoint = "/api/trpc/\(procedure)"
        
        // Encode input to JSON
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let inputData = try encoder.encode(input)
        let inputJSON = try JSONSerialization.jsonObject(with: inputData) as? [String: Any] ?? [:]
        
        // Get auth token if available
        let token = UserDefaults.standard.string(forKey: "authToken")
        
        // Make the request
        return try await networkManager.request(
            endpoint: endpoint,
            method: .post,
            body: ["input": inputJSON],
            token: token
        )
    }
}
