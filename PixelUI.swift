import SwiftUI

// MARK: - Rajasthani × Ikebana Color Palette
struct AppColors {
    // Core Heritage
    static let sandstone    = Color(red: 0.94, green: 0.87, blue: 0.73)
    static let deepMaroon   = Color(red: 0.50, green: 0.05, blue: 0.05)
    static let royalGold    = Color(red: 0.85, green: 0.65, blue: 0.13)
    static let jaipurPink   = Color(red: 0.93, green: 0.51, blue: 0.51)
    static let mograWhite   = Color(red: 0.98, green: 0.98, blue: 0.95)
    static let turquoise    = Color(red: 0.25, green: 0.51, blue: 0.51)
    static let heritageBlue = Color(red: 0.08, green: 0.12, blue: 0.32)

    // Expanded
    static let saffron      = Color(red: 1.00, green: 0.60, blue: 0.10)
    static let indigo       = Color(red: 0.20, green: 0.15, blue: 0.55)
    static let lakeTeal     = Color(red: 0.18, green: 0.58, blue: 0.56)
    static let desertRose   = Color(red: 0.80, green: 0.40, blue: 0.45)
    static let pushkarRose  = Color(red: 0.85, green: 0.55, blue: 0.65)
    static let fortAmber    = Color(red: 0.72, green: 0.58, blue: 0.38)
}

// MARK: - Glassmorphic Card
struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.25), Color.white.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        self.modifier(GlassCard(cornerRadius: cornerRadius))
    }
}

// MARK: - Jharokha Card
struct JharokhaCard: ViewModifier {
    var color: Color = AppColors.sandstone
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppColors.royalGold.opacity(0.5), lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
    }
}

extension View {
    func jharokhaStyle(color: Color = AppColors.sandstone) -> some View {
        self.modifier(JharokhaCard(color: color))
    }
}

// MARK: - Ornamental Divider
struct OrnamentalDivider: View {
    var color: Color = AppColors.royalGold
    var body: some View {
        HStack(spacing: 8) {
            capsuleLine
            Image(systemName: "diamond.fill")
                .font(.system(size: 5))
                .foregroundColor(color.opacity(0.5))
            capsuleLine
        }
        .padding(.vertical, 6)
    }
    private var capsuleLine: some View {
        Capsule().fill(color.opacity(0.2)).frame(height: 1)
    }
}

// MARK: - Theme-Aware Background
struct ThemedBackground: View {
    let theme: CityTheme
    @State private var phase: Double = 0
    
    var body: some View {
        ZStack {
            // Base gradient from theme
            LinearGradient(
                colors: [
                    theme.accent.opacity(0.15),
                    AppColors.heritageBlue,
                    theme.accent.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle animated overlay
            TimelineView(.animation(minimumInterval: 0.05)) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate
                Canvas { context, size in
                    for i in 0..<2 {
                        let fi = CGFloat(i)
                        let cx = size.width * (0.3 + 0.4 * sin(t * 0.05 + fi * 2))
                        let cy = size.height * (0.3 + 0.4 * cos(t * 0.04 + fi * 1.5))
                        let r = min(size.width, size.height) * 0.35
                        context.opacity = 0.08
                        context.fill(
                            Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)),
                            with: .color(theme.accent)
                        )
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Pulsing Glow
struct PulsingGlow: ViewModifier {
    let color: Color
    let radius: CGFloat
    @State private var isGlowing = false
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(isGlowing ? 0.5 : 0.1), radius: isGlowing ? radius : radius / 3)
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isGlowing = true
                }
            }
    }
}

extension View {
    func pulsingGlow(color: Color = AppColors.royalGold, radius: CGFloat = 12) -> some View {
        self.modifier(PulsingGlow(color: color, radius: radius))
    }
}

// MARK: - Scale Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Theme-Aware RajButton
struct RajButton: View {
    let title: String
    let icon: String?
    let color: Color
    var fontSize: CGFloat
    var compact: Bool
    let action: () -> Void

    init(_ title: String, icon: String? = nil, color: Color = AppColors.deepMaroon,
         fontSize: CGFloat = 14, compact: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.fontSize = fontSize
        self.compact = compact
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: compact ? 0 : 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: compact ? fontSize : fontSize - 1, weight: .semibold))
                }
                if !compact {
                    Text(title)
                        .font(.custom("Georgia", size: fontSize).bold())
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, compact ? 12 : 18)
            .padding(.vertical, compact ? 8 : 10)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.85), color.opacity(0.55)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                Capsule().stroke(Color.white.opacity(0.2), lineWidth: 0.8)
            )
            .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Floating Petal
struct FloatingPetal: View {
    let index: Int
    let color: Color
    @State private var yOffset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0

    var body: some View {
        Image(systemName: "leaf.fill")
            .font(.system(size: CGFloat.random(in: 8...16)))
            .foregroundColor(color.opacity(0.12))
            .rotationEffect(.degrees(rotation))
            .offset(y: yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.linear(duration: Double.random(in: 10...18)).repeatForever(autoreverses: false)) {
                    yOffset = -800
                    rotation = Double.random(in: 180...720)
                }
                withAnimation(.easeIn(duration: 1.5)) { opacity = 1 }
            }
    }
}
