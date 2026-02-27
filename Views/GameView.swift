import SwiftUI
import SpriteKit

struct GameView: View {
    @EnvironmentObject var gameState: GameState
    @State private var scene: MandalaScene?
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.width < 400
            let theme = gameState.activeTheme
            
            ZStack {
                Color(UIColor(theme.bgColor).withAlphaComponent(0.15))
                    .ignoresSafeArea()

                if let activeScene = scene {
                    SpriteView(scene: activeScene, options: [.allowsTransparency])
                        .ignoresSafeArea()
                }

                VStack(spacing: 0) {
                    // HUD
                    HarmonyHUDView()
                        .padding(.horizontal, isCompact ? 8 : 16)
                        .padding(.top, 6)

                    Spacer()
                    
                    // Floating Undo/Redo
                    HStack(spacing: 10) {
                        Spacer()
                        Button(action: {
                            NotificationCenter.default.post(name: .undoAction, object: nil)
                            HapticManager.shared.toolSwitch()
                        }) {
                            Image(systemName: "arrow.uturn.backward.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(theme.accent.opacity(gameState.canUndo ? 0.9 : 0.2))
                        }
                        .disabled(!gameState.canUndo)
                        
                        Button(action: {
                            NotificationCenter.default.post(name: .redoAction, object: nil)
                            HapticManager.shared.toolSwitch()
                        }) {
                            Image(systemName: "arrow.uturn.forward.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(theme.accent.opacity(gameState.canRedo ? 0.9 : 0.2))
                        }
                        .disabled(!gameState.canRedo)
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 4)

                    // Bottom
                    VStack(spacing: 6) {
                        // Compact toolbar
                        HStack(spacing: isCompact ? 8 : 12) {
                            RajButton("Reset", icon: "arrow.counterclockwise", color: AppColors.deepMaroon, fontSize: isCompact ? 11 : 13, compact: isCompact) {
                                scene?.resetBoard()
                            }
                            
                            Spacer()
                            
                            RajButton("Save & Insight", icon: "sparkles", color: theme.accent, fontSize: isCompact ? 11 : 13, compact: isCompact) {
                                saveMandalaAndShowInsight()
                            }
                            
                            Spacer()
                            
                            RajButton("Menu", icon: "house", color: AppColors.indigo, fontSize: isCompact ? 11 : 13, compact: isCompact) {
                                gameState.navigate(to: .menu)
                            }
                        }
                        .padding(.horizontal, isCompact ? 6 : 14)

                        // Palette
                        PaletteView(selectedVariant: $gameState.selectedFlower, selectedGridShape: $gameState.selectedGridShape)
                            .frame(height: isCompact ? 110 : 120)
                            .padding(.horizontal, 6)
                            .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? 0 : 6)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(AppColors.mograWhite.opacity(0.9))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(theme.accent.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                
                if !hasSeenOnboarding {
                    OnboardingView(theme: theme)
                        .transition(.opacity.combined(with: .scale))
                        .zIndex(100)
                }
            }
        }
        .onAppear { setupScene() }
    }

    private func setupScene() {
        if gameState.shouldResetScene || scene == nil {
            gameState.shouldResetScene = false
            let s = MandalaScene()
            s.size = UIScreen.main.bounds.size
            s.scaleMode = .resizeFill
            s.gameState = gameState
            s.onMandalaUpdate = { [weak gameState] slots in
                gameState?.evaluateHarmony(slots: slots)
            }
            scene = s
        }
    }

    private func saveMandalaAndShowInsight() {
        guard let skView = scene?.view else { return }
        UIGraphicsBeginImageContextWithOptions(skView.bounds.size, false, 0)
        skView.drawHierarchy(in: skView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let pngData = image?.pngData() {
            gameState.saveSnapshot(imageData: pngData)
            if gameState.currentInsight != nil {
                gameState.navigate(to: .insight)
            }
        }
    }
}
