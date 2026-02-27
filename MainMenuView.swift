import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var gameState: GameState
    @State private var logoRotation: Double = 0
    @State private var breathScale: CGFloat = 1.0

    var body: some View {
        let theme = gameState.activeTheme
        
        ZStack {
            ThemedBackground(theme: theme)

            // Floating petals in theme color
            GeometryReader { geo in
                ForEach(0..<8, id: \.self) { i in
                    FloatingPetal(index: i, color: theme.accent)
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: geo.size.height + CGFloat(i * 70)
                        )
                }
            }

            GeometryReader { geo in
                let isCompact = geo.size.width < 400
                let titleSize: CGFloat = isCompact ? 38 : 50
                let subtitleSize: CGFloat = isCompact ? 30 : 38
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer().frame(height: isCompact ? 40 : 60)

                        // Rotating mandala icon
                        ZStack {
                            ForEach(0..<8, id: \.self) { i in
                                Capsule()
                                    .fill(theme.accent.opacity(0.25))
                                    .frame(width: 3, height: 24)
                                    .offset(y: -20)
                                    .rotationEffect(.degrees(Double(i) * 45))
                            }
                            .rotationEffect(.degrees(logoRotation))
                            
                            Circle()
                                .fill(theme.accent.opacity(0.15))
                                .frame(width: 14, height: 14)
                        }
                        .pulsingGlow(color: theme.accent, radius: 16)
                        .padding(.bottom, 12)

                        // Title
                        VStack(spacing: 2) {
                            Text("MANDALA")
                                .font(.custom("Georgia", size: titleSize).bold())
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [AppColors.mograWhite, theme.accent.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Text("GARDEN")
                                .font(.custom("Georgia", size: subtitleSize).bold())
                                .foregroundColor(theme.accent)

                            Text("\(theme.name) Edition")
                                .font(.custom("Georgia", size: isCompact ? 11 : 13).italic())
                                .foregroundColor(AppColors.mograWhite.opacity(0.45))
                                .padding(.top, 4)
                        }
                        .scaleEffect(breathScale)

                        OrnamentalDivider(color: theme.accent)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 12)

                        // Menu Buttons
                        VStack(spacing: 14) {
                            RajButton("Create Mandala", icon: "leaf.fill", color: theme.accent, fontSize: isCompact ? 15 : 18) {
                                gameState.startNewMandala()
                            }

                            RajButton("Gallery", icon: "photo.on.rectangle.angled", color: theme.ringColor, fontSize: isCompact ? 15 : 18) {
                                gameState.navigate(to: .gallery)
                            }

                            HStack(spacing: 12) {
                                RajButton("Settings", icon: "slider.horizontal.3", color: AppColors.indigo, fontSize: isCompact ? 12 : 14) {
                                    gameState.navigate(to: .settings)
                                }
                                RajButton("About", icon: "info.circle", color: AppColors.fortAmber, fontSize: isCompact ? 12 : 14) {
                                    gameState.navigate(to: .about)
                                }
                            }
                        }

                        Spacer().frame(height: 40)

                        
                    }
                    .frame(minHeight: geo.size.height)
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                logoRotation = 360
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                breathScale = 1.03
            }
        }
    }
}
