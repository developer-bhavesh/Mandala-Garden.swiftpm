import SwiftUI

struct HarmonyHUDView: View {
    @EnvironmentObject var gameState: GameState
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        let theme = gameState.activeTheme
        
        HStack(spacing: 8) {
            // Mood icon
            Image(systemName: gameState.currentMoodIcon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(theme.accent)
                .scaleEffect(pulseScale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        pulseScale = 1.12
                    }
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(gameState.currentMoodLabel)
                    .font(.custom("Georgia", size: 11).bold())
                    .foregroundColor(theme.accent)
                    .lineLimit(1)
                
                // Score bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.black.opacity(0.06)).frame(height: 4)
                        Capsule()
                            .fill(LinearGradient(colors: [theme.accent.opacity(0.6), theme.accent], startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(0, geo.size.width * CGFloat(gameState.harmonyScore) / 100.0), height: 4)
                            .animation(.spring(response: 0.5), value: gameState.harmonyScore)
                    }
                }
                .frame(height: 5)
            }
            
            Text("\(gameState.harmonyScore)%")
                .font(.custom("Georgia", size: 16).bold())
                .foregroundColor(theme.accent)
                .frame(minWidth: 36, alignment: .trailing)
            
            // Streak indicator
            if gameState.currentStreak >= 3 {
                HStack(spacing: 2) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.saffron)
                    Text("\(gameState.currentStreak)")
                        .font(.custom("Georgia", size: 10).bold())
                        .foregroundColor(AppColors.saffron)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Capsule().fill(AppColors.saffron.opacity(0.15)))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppColors.mograWhite.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(theme.accent.opacity(0.15), lineWidth: 1)
        )
    }
}
