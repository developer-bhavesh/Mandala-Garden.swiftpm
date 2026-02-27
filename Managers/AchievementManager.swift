import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let icon: String // SF Symbol
}

@MainActor
class AchievementManager {
    static let shared = AchievementManager()
    
    let allAchievements: [Achievement] = [
        Achievement(id: "first_mandala", title: "First Seed", description: "Created your very first mandala.", icon: "leaf.fill"),
        Achievement(id: "color_explorer", title: "Color Explorer", description: "Used all available flower tints.", icon: "paintpalette.fill"),
        Achievement(id: "theme_tourist", title: "Theme Tourist", description: "Created mandalas in all city themes.", icon: "map.fill"),
        Achievement(id: "streak_master", title: "Streak Master", description: "Achieved a placement streak of 10+.", icon: "flame.fill"),
        Achievement(id: "perfect_symmetry", title: "Perfect Symmetry", description: "Completed a full ring using Mirror Mode / Slide Fill.", icon: "arrow.triangle.2.circlepath"),
        Achievement(id: "five_saved", title: "Curator", description: "Saved 5 mandalas to your gallery.", icon: "photo.stack.fill"),
        Achievement(id: "daily_devotee", title: "Daily Devotee", description: "Completed a Daily Challenge.", icon: "sun.max.fill")
    ]
    
    // Checks conditions and returns an array of NEWLY unlocked achievement IDs.
    // In a real app, this would deeply check GameState history. We abstract the checks here based on available state.
    func checkAchievements(gameState: GameState, latestStreak: Int = 0) -> [String] {
        var newlyUnlocked: [String] = []
        let alreadyUnlocked = gameState.unlockedAchievements
        
        func unlock(_ id: String) {
            if !alreadyUnlocked.contains(id) { newlyUnlocked.append(id) }
        }
        
        if gameState.savedMandalas.count >= 1 { unlock("first_mandala") }
        if gameState.savedMandalas.count >= 5 { unlock("five_saved") }
        if latestStreak >= 10 { unlock("streak_master") }
        
        let allThemesCount = CityTheme.allThemes.count
        let usedThemes = Set(gameState.savedMandalas.map { $0.themeName })
        if usedThemes.count >= allThemesCount && allThemesCount > 0 { unlock("theme_tourist") }
        
        // Return only the ones that weren't unlocked before
        return newlyUnlocked
    }
}
