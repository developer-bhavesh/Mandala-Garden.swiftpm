import SwiftUI

@main
struct MyApp: App {
    @StateObject private var gameState = GameState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameState)
                // Set the default color scheme to remain consistent with pixel art theme
                .preferredColorScheme(.dark)
        }
    }
}
