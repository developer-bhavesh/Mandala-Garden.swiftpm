import SwiftUI

/// Rajasthani city theme for the mandala background
struct CityTheme {
    let name: String
    let subtitle: String
    let bgColor: Color
    let ringColor: Color
    let accent: Color
    let icon: String  // SF Symbol name

    static let jaipur = CityTheme(
        name: "Jaipur", subtitle: "The Pink City",
        bgColor: Color(red: 0.96, green: 0.88, blue: 0.84),
        ringColor: Color(red: 0.85, green: 0.65, blue: 0.50),
        accent: AppColors.jaipurPink, icon: "building.2.fill"
    )
    static let jodhpur = CityTheme(
        name: "Jodhpur", subtitle: "The Blue City",
        bgColor: Color(red: 0.82, green: 0.88, blue: 0.96),
        ringColor: Color(red: 0.45, green: 0.55, blue: 0.75),
        accent: Color(red: 0.30, green: 0.45, blue: 0.70), icon: "house.lodge.fill"
    )
    static let udaipur = CityTheme(
        name: "Udaipur", subtitle: "City of Lakes",
        bgColor: Color(red: 0.87, green: 0.94, blue: 0.87),
        ringColor: Color(red: 0.50, green: 0.72, blue: 0.55),
        accent: Color(red: 0.35, green: 0.60, blue: 0.45), icon: "drop.fill"
    )
    static let jaisalmer = CityTheme(
        name: "Jaisalmer", subtitle: "The Golden City",
        bgColor: Color(red: 0.96, green: 0.90, blue: 0.76),
        ringColor: Color(red: 0.85, green: 0.70, blue: 0.40),
        accent: Color(red: 0.90, green: 0.65, blue: 0.20), icon: "sun.max.fill"
    )
    static let bikaner = CityTheme(
        name: "Bikaner", subtitle: "The Red City",
        bgColor: Color(red: 0.94, green: 0.82, blue: 0.80),
        ringColor: Color(red: 0.75, green: 0.45, blue: 0.40),
        accent: Color(red: 0.65, green: 0.25, blue: 0.25), icon: "tent.fill"
    )
    static let pushkar = CityTheme(
        name: "Pushkar", subtitle: "The Rose City",
        bgColor: Color(red: 0.95, green: 0.85, blue: 0.88),
        ringColor: Color(red: 0.80, green: 0.50, blue: 0.60),
        accent: AppColors.pushkarRose, icon: "leaf.circle.fill"
    )
    static let chittorgarh = CityTheme(
        name: "Chittorgarh", subtitle: "The Fort City",
        bgColor: Color(red: 0.88, green: 0.85, blue: 0.78),
        ringColor: Color(red: 0.60, green: 0.50, blue: 0.38),
        accent: AppColors.fortAmber, icon: "shield.fill"
    )

    static let allThemes: [CityTheme] = [.jaipur, .jodhpur, .udaipur, .jaisalmer, .bikaner, .pushkar, .chittorgarh]

    static func forKey(_ key: String) -> CityTheme {
        switch key {
        case "jodhpur": return .jodhpur
        case "udaipur": return .udaipur
        case "jaisalmer": return .jaisalmer
        case "bikaner": return .bikaner
        case "pushkar": return .pushkar
        case "chittorgarh": return .chittorgarh
        default: return .jaipur
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var gameState: GameState

    var body: some View {
        let theme = gameState.activeTheme
        
        ZStack {
            ThemedBackground(theme: theme)

            GeometryReader { geo in
                let isCompact = geo.size.width < 400
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        Text("SETTINGS")
                            .font(.custom("Georgia", size: isCompact ? 32 : 40).bold())
                            .foregroundColor(AppColors.mograWhite)
                            .padding(.top, 30)

                        // Mandala Theme
                        settingsSection(title: "Mandala Theme", theme: theme) {
                            VStack(spacing: 8) {
                                ForEach(ResourceManager.shared.allGrids, id: \.self) { gridKey in
                                    let t = CityTheme.forKey(gridKey)
                                    let isSelected = gameState.selectedGrid == gridKey

                                    Button(action: {
                                        gameState.selectedGrid = gridKey
                                    }) {
                                        HStack(spacing: 10) {
                                            ZStack {
                                                Circle().fill(t.bgColor).frame(width: 42, height: 42)
                                                Circle().stroke(t.ringColor, lineWidth: 1.5).frame(width: 32, height: 32)
                                                Image(systemName: t.icon)
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(t.accent)
                                            }
                                            VStack(alignment: .leading, spacing: 1) {
                                                Text(t.name)
                                                    .font(.custom("Georgia", size: isCompact ? 14 : 16).bold())
                                                    .foregroundColor(AppColors.mograWhite)
                                                Text(t.subtitle)
                                                    .font(.custom("Georgia", size: 10).italic())
                                                    .foregroundColor(theme.accent.opacity(0.7))
                                            }
                                            Spacer()
                                            if isSelected {
                                                Image(systemName: "checkmark.circle.fill").foregroundColor(theme.accent).font(.system(size: 16))
                                            }
                                        }
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 12).fill(isSelected ? theme.accent.opacity(0.12) : Color.white.opacity(0.04)))
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? theme.accent : Color.clear, lineWidth: 1.5))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        // Symmetry
                        settingsSection(title: "Symmetry Folds", theme: theme) {
                            HStack(spacing: 10) {
                                foldButton(title: "4", subtitle: "Fold", count: 4, theme: theme)
                                foldButton(title: "6", subtitle: "Fold", count: 6, theme: theme)
                                foldButton(title: "8", subtitle: "Fold", count: 8, theme: theme)
                            }
                        }

                        // Rings
                        settingsSection(title: "Grid Rings", theme: theme) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    foldButton(title: "0", subtitle: "Rings", count: 0, theme: theme, isRing: true)
                                    foldButton(title: "3", subtitle: "Rings", count: 3, theme: theme, isRing: true)
                                    foldButton(title: "4", subtitle: "Rings", count: 4, theme: theme, isRing: true)
                                    foldButton(title: "5", subtitle: "Rings", count: 5, theme: theme, isRing: true)
                                    foldButton(title: "6", subtitle: "Rings", count: 6, theme: theme, isRing: true)
                                }
                            }
                        }

                        Spacer(minLength: 16)

                        RajButton("BACK", icon: "arrow.left", color: theme.accent) {
                            gameState.navigate(to: .menu)
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, isCompact ? 14 : 24)
                }
            }
        }
    }

    private func settingsSection(title: String, theme: CityTheme, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("Georgia", size: 18).bold())
                .foregroundColor(theme.accent)
            content()
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.06)))
    }

    private func foldButton(title: String, subtitle: String, count: Int, theme: CityTheme, isRing: Bool = false) -> some View {
        let isSelected = isRing ? gameState.ringCount == count : gameState.symmetryCount == count
        return Button(action: {
            if isRing { gameState.ringCount = count }
            else { gameState.symmetryCount = count }
        }) {
            VStack(spacing: 1) {
                Text(title).font(.custom("Georgia", size: 22).bold())
                Text(subtitle).font(.custom("Georgia", size: 10))
            }
            .foregroundColor(isSelected ? .white : AppColors.mograWhite.opacity(0.6))
            .frame(width: 58, height: 50)
            .background(isSelected ? theme.accent : Color.black.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? theme.accent : Color.clear, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }
}
