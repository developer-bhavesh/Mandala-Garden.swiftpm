import SwiftUI

struct AboutView: View {
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        let theme = gameState.activeTheme
        
        ZStack {
            ThemedBackground(theme: theme)
            
            GeometryReader { geo in
                let isCompact = geo.size.width < 400
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        VStack(spacing: 3) {
                            Text("ABOUT")
                                .font(.custom("Georgia", size: isCompact ? 32 : 40).bold())
                                .foregroundColor(AppColors.mograWhite)
                            Text("Flower Mandala")
                                .font(.custom("Georgia", size: 12).italic())
                                .foregroundColor(theme.accent.opacity(0.5))
                        }
                        .padding(.top, 30)
                        
                        OrnamentalDivider(color: theme.accent).padding(.horizontal, 40)
                        
                        infoCard(icon: "building.columns.fill", title: "Rajasthani Mandala Art",
                            text: "Inspired by the geometric brilliance of Jali latticework, Rangoli patterns, and the sacred symmetry found in Rajasthani temple art and palace architecture.", theme: theme)
                        
                        infoCard(icon: "leaf.fill", title: "Flower Garden",
                            text: "Create radiant mandalas using flowers native to Rajasthan — Marigold, Lotus, Rose, Jasmine, and more. Each flower carries cultural significance in festivals and rituals.", theme: theme)
                        
                        infoCard(icon: "circle.hexagongrid.fill", title: "Patterns & Symmetry",
                            text: "Arrange flowers across rings and symmetry folds to craft intricate patterns. Use color tints and different flower combinations to express your creativity.", theme: theme)
                        
                        infoCard(icon: "chart.bar.xaxis", title: "7D Scoring",
                            text: "Symmetry • Color Harmony • Completeness • Ring Variety • Flow • Complexity • Tint Usage — master all seven dimensions to achieve harmony.", theme: theme)
                        
                        infoCard(icon: "accessibility", title: "Accessibility",
                            text: "Dynamic Type, high contrast colors, and responsive layout for all devices.", theme: theme)
                        
                        OrnamentalDivider(color: theme.accent).padding(.horizontal, 40)
                        
                        VStack(spacing: 4) {
                            Text("WWDC26 Swift Student Challenge")
                                .font(.custom("Georgia", size: 12).bold())
                                .foregroundColor(theme.accent)
                            Text("SwiftUI · SpriteKit · NaturalLanguage")
                                .font(.custom("Georgia", size: 10))
                                .foregroundColor(AppColors.mograWhite.opacity(0.3))
                        }
                        
                        RajButton("BACK", icon: "arrow.left", color: theme.accent) {
                            gameState.navigate(to: .menu)
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, isCompact ? 14 : 20)
                }
            }
        }
    }
    
    private func infoCard(icon: String, title: String, text: String, theme: CityTheme) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(theme.accent)
                Text(title)
                    .font(.custom("Georgia", size: 15).bold())
                    .foregroundColor(theme.accent)
            }
            Text(text)
                .font(.custom("Georgia", size: 12))
                .foregroundColor(AppColors.mograWhite.opacity(0.65))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 14)
    }
}
