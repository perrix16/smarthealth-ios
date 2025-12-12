import SwiftUI

@main
struct SmartHealthApp: App {
    @StateObject private var authService = AuthService.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Smart Health - Solid Backend Integrated")
            .padding()
    }
}
