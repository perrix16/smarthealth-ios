//
//  DashboardView.swift
//  SmartHealth
//
//  Created by Salvatore on 10/12/2025.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var authService = AuthService.shared
    @State private var showingProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back,")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text(authService.currentUser?.name ?? authService.currentUser?.email ?? "User")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    // Health metrics cards
                    VStack(spacing: 15) {
                        HealthMetricCard(
                            icon: "heart.fill",
                            title: "Heart Rate",
                            value: "--",
                            unit: "BPM",
                            color: .red
                        )
                        
                        HealthMetricCard(
                            icon: "figure.walk",
                            title: "Steps",
                            value: "--",
                            unit: "steps",
                            color: .green
                        )
                        
                        HealthMetricCard(
                            icon: "bed.double.fill",
                            title: "Sleep",
                            value: "--",
                            unit: "hours",
                            color: .blue
                        )
                        
                        HealthMetricCard(
                            icon: "flame.fill",
                            title: "Calories",
                            value: "--",
                            unit: "kcal",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                    
                    // Quick actions
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            QuickActionButton(
                                icon: "plus.circle.fill",
                                title: "Log Data",
                                color: .blue
                            )
                            
                            QuickActionButton(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "View Charts",
                                color: .purple
                            )
                            
                            QuickActionButton(
                                icon: "bell.fill",
                                title: "Reminders",
                                color: .orange
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("SmartHealth")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingProfile = true }) {
                        Image(systemName: "person.circle")
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
        }
    }
}

// MARK: - Health Metric Card
struct HealthMetricCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Quick Action Button
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Profile View (placeholder)
struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authService = AuthService.shared
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text(authService.currentUser?.email ?? "")
                    Text(authService.currentUser?.name ?? "No name")
                }
                
                Section {
                    Button("Logout", role: .destructive) {
                        authService.signOut()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
