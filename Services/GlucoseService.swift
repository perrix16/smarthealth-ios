//
//  GlucoseService.swift
//  SmartHealth
//
//  Created by Salvatore on 12/12/2025.
//  Service for glucose readings from Solid Backend
//

import Foundation

/// Glucose reading model
struct GlucoseReading: Codable, Identifiable {
    let id: String
    let value: Double
    let unit: String
    let timestamp: Date
    let userId: String
    let notes: String?
}

/// Input for creating a glucose reading
struct CreateGlucoseInput: Codable {
    let value: Double
    let unit: String
    let timestamp: Date
    let notes: String?
    
    init(value: Double, unit: String = "mg/dL", timestamp: Date = Date(), notes: String? = nil) {
        self.value = value
        self.unit = unit
        self.timestamp = timestamp
        self.notes = notes
    }
}

/// Empty input for procedures that don't require parameters
struct EmptyInput: Codable {}

/// Service for managing glucose readings
final class GlucoseService {
    static let shared = GlucoseService()
    private init() {}
    
    /// Get all glucose readings for the authenticated user
    /// - Returns: Array of glucose readings
    func getReadings() async throws -> [GlucoseReading] {
        return try await TRPCClient.shared.call(
            procedure: "glucoseReadings.list",
            input: EmptyInput()
        )
    }
    
    /// Create a new glucose reading
    /// - Parameters:
    ///   - value: Glucose value
    ///   - unit: Unit of measurement (default: mg/dL)
    ///   - timestamp: Time of reading (default: now)
    ///   - notes: Optional notes
    /// - Returns: The created reading
    func createReading(
        value: Double,
        unit: String = "mg/dL",
        timestamp: Date = Date(),
        notes: String? = nil
    ) async throws -> GlucoseReading {
        let input = CreateGlucoseInput(
            value: value,
            unit: unit,
            timestamp: timestamp,
            notes: notes
        )
        
        return try await TRPCClient.shared.call(
            procedure: "glucoseReadings.create",
            input: input
        )
    }
    
    /// Delete a glucose reading
    /// - Parameter id: Reading ID to delete
    func deleteReading(id: String) async throws {
        struct DeleteInput: Codable {
            let id: String
        }
        
        let _: EmptyInput = try await TRPCClient.shared.call(
            procedure: "glucoseReadings.delete",
            input: DeleteInput(id: id)
        )
    }
    
    /// Get glucose statistics
    /// - Returns: Statistics about glucose readings
    func getStatistics() async throws -> GlucoseStatistics {
        return try await TRPCClient.shared.call(
            procedure: "glucoseReadings.statistics",
            input: EmptyInput()
        )
    }
}

/// Glucose statistics
struct GlucoseStatistics: Codable {
    let average: Double
    let minimum: Double
    let maximum: Double
    let count: Int
    let last7DaysAverage: Double?
    let last30DaysAverage: Double?
}
