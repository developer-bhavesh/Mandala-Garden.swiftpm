import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    let theme: CityTheme
    @State private var step = 0
    
    let steps: [(title: String, desc: String, icon: String)] = [
        ("Welcome to Mandala Garden", "Create beautiful, symmetrical art inspired by Rajasthani heritage.", "leaf.fill"),
        ("Place & Erase", "Tap any slot to place a flower. Select the Eraser to remove one.", "hand.tap.fill"),
        ("Slide Fill", "Select the Slide Fill tool and drag across slots to quickly paint entire rings.", "hand.draw.fill"),
        ("Pan & Zoom", "Pinch to zoom in or out. Use two fingers to pan around the canvas.", "arrow.up.and.down.and.arrow.left.and.right"),
        ("Discover Yourself", "Tap 'Save & Insight' to see what your mandala reveals about your personality.", "sparkles")
    ]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header image/icon
                ZStack {
                    Circle()
                        .fill(theme.accent.opacity(0.2))
                        .frame(width: 80, height: 80)
                    Image(systemName: steps[step].icon)
                        .font(.system(size: 36))
                        .foregroundColor(theme.accent)
                }
                
                // Text
                VStack(spacing: 12) {
                    Text(steps[step].title)
                        .font(.custom("Georgia", size: 22).bold())
                        .foregroundColor(AppColors.mograWhite)
                        .multilineTextAlignment(.center)
                    
                    Text(steps[step].desc)
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(AppColors.mograWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Dots
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { i in
                        Circle()
                            .fill(i == step ? theme.accent : Color.white.opacity(0.2))
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: step)
                    }
                }
                .padding(.vertical, 10)
                
                // Button
                RajButton(step < steps.count - 1 ? "Next" : "Start Creating", icon: step < steps.count - 1 ? "arrow.right" : "paintbrush.fill", color: theme.accent) {
                    withAnimation {
                        if step < steps.count - 1 {
                            step += 1
                            HapticManager.shared.toolSwitch()
                        } else {
                            hasSeenOnboarding = true
                            HapticManager.shared.streak()
                        }
                    }
                }
            }
            .padding(30)
            .glassCard(cornerRadius: 24)
            .padding(30)
            .frame(maxWidth: 400)
        }
    }
}
