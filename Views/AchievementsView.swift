import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var gameState: GameState
    let theme: CityTheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            theme.bgColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Achievements")
                        .font(.custom("Georgia", size: 28).bold())
                        .foregroundColor(theme.accent)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(theme.accent.opacity(0.5))
                    }
                }
                .padding(20)
                
                // Progress
                let unlocked = gameState.unlockedAchievements.count
                let total = AchievementManager.shared.allAchievements.count
                Text("\(unlocked) of \(total) Unlocked")
                    .font(.custom("Georgia", size: 14).bold())
                    .foregroundColor(theme.accent.opacity(0.8))
                    .padding(.bottom, 20)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(AchievementManager.shared.allAchievements) { achievement in
                            let isUnlocked = gameState.unlockedAchievements.contains(achievement.id)
                            
                            HStack(spacing: 16) {
                                // Icon
                                ZStack {
                                    Circle()
                                        .fill(isUnlocked ? theme.accent : theme.accent.opacity(0.1))
                                        .frame(width: 50, height: 50)
                                    Image(systemName: achievement.icon)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(isUnlocked ? theme.bgColor : theme.accent.opacity(0.3))
                                }
                                
                                // Text
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(achievement.title)
                                        .font(.custom("Georgia", size: 16).bold())
                                        .foregroundColor(isUnlocked ? theme.accent : theme.accent.opacity(0.5))
                                    Text(achievement.description)
                                        .font(.custom("Georgia", size: 12))
                                        .foregroundColor(isUnlocked ? AppColors.indigo.opacity(0.8) : AppColors.indigo.opacity(0.4))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                Spacer()
                                
                                if isUnlocked {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(theme.accent)
                                        .font(.system(size: 14, weight: .bold))
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(isUnlocked ? .ultraThinMaterial : .ultraThinMaterial)
                                    .opacity(isUnlocked ? 1.0 : 0.6)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(isUnlocked ? theme.accent.opacity(0.3) : Color.clear, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
