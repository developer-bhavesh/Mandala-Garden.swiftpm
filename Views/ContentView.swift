import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        Group {
            switch gameState.currentScreen {
            case .menu:
                MainMenuView()
                    .transition(.opacity)
            case .game:
                GameView()
                    .transition(.scale(scale: 0.95).combined(with: .opacity))
            case .gallery:
                GalleryView()
                    .transition(.opacity.combined(with: .slide))
            case .settings:
                SettingsView()
                    .transition(.opacity.combined(with: .slide))
            case .about:
                AboutView()
                    .transition(.opacity.combined(with: .slide))
            case .insight:
                if let insight = gameState.currentInsight {
                    InsightView(insight: insight)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                } else {
                    MainMenuView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: gameState.currentScreen)
    }
}
