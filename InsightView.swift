import SwiftUI

struct InsightView: View {
    @EnvironmentObject var gameState: GameState
    let insight: MandalaInsight
    
    @State private var animateRadar = false
    @State private var showContent = false
    
    var body: some View {
        let theme = gameState.activeTheme
        let report = gameState.currentReport
        
        ZStack {
            ThemedBackground(theme: theme)
            
            GeometryReader { geo in
                let isCompact = geo.size.width < 400
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Title
                        VStack(spacing: 3) {
                            Text("YOUR INSIGHT")
                                .font(.custom("Georgia", size: isCompact ? 24 : 28).bold())
                                .foregroundColor(AppColors.mograWhite)
                            Text("Art · Soul · Heritage")
                                .font(.custom("Georgia", size: 11).italic())
                                .foregroundColor(theme.accent.opacity(0.5))
                        }
                        .padding(.top, 24)

                        // Animated score ring
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.08), lineWidth: 5)
                                .frame(width: 90, height: 90)
                            Circle()
                                .trim(from: 0, to: animateRadar ? CGFloat(insight.harmonyScore) / 100.0 : 0)
                                .stroke(
                                    LinearGradient(colors: [theme.accent, AppColors.saffron], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                                )
                                .frame(width: 90, height: 90)
                                .rotationEffect(.degrees(-90))
                            VStack(spacing: 0) {
                                Text("\(insight.harmonyScore)")
                                    .font(.custom("Georgia", size: 28).bold())
                                    .foregroundColor(AppColors.mograWhite)
                                Text("harmony")
                                    .font(.custom("Georgia", size: 9))
                                    .foregroundColor(theme.accent.opacity(0.5))
                            }
                        }

                        if showContent {
                            // Mood Card
                            VStack(spacing: 8) {
                                Image(systemName: insight.mood.icon)
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundColor(theme.accent)
                                Text(insight.mood.rawValue)
                                    .font(.custom("Georgia", size: 18).bold())
                                    .foregroundColor(AppColors.mograWhite)
                                Text(insight.mood.description)
                                    .font(.custom("Georgia", size: 12))
                                    .foregroundColor(AppColors.mograWhite.opacity(0.65))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity)
                            .glassCard(cornerRadius: 14)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))

                            // Did You Know — Mood
                            didYouKnowCard(fact: insight.mood.didYouKnow, theme: theme)

                            // Radar Chart
                            VStack(spacing: 8) {
                                Text("7D Analysis")
                                    .font(.custom("Georgia", size: 14).bold())
                                    .foregroundColor(theme.accent)
                                RadarChartView(dimensions: insight.dimensions, color: theme.accent)
                                    .frame(height: isCompact ? 180 : 200)
                                    .padding(.horizontal, 16)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .glassCard(cornerRadius: 14)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            
                            // ===== PERSONALITY REPORT =====
                            
                            if let report = report {
                                // Big Five Personality
                                VStack(spacing: 10) {
                                    sectionHeader(icon: "person.fill", title: "Big Five Personality", theme: theme)
                                    
                                    Text(report.bigFive.dominantTrait)
                                        .font(.custom("Georgia", size: 16).bold())
                                        .foregroundColor(theme.accent)
                                    
                                    Text(report.bigFive.description)
                                        .font(.custom("Georgia", size: 11))
                                        .foregroundColor(AppColors.mograWhite.opacity(0.65))
                                        .multilineTextAlignment(.center)
                                    
                                    VStack(spacing: 4) {
                                        traitBar("Openness", report.bigFive.openness, theme)
                                        traitBar("Conscientious", report.bigFive.conscientiousness, theme)
                                        traitBar("Extraversion", report.bigFive.extraversion, theme)
                                        traitBar("Agreeableness", report.bigFive.agreeableness, theme)
                                        traitBar("Stability", 1.0 - report.bigFive.neuroticism, theme)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity)
                                .glassCard(cornerRadius: 14)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                                
                                // Cognitive Style
                                VStack(spacing: 10) {
                                    sectionHeader(icon: report.cognitiveStyle.icon, title: "Cognitive Style", theme: theme)
                                    
                                    Text(report.cognitiveStyle.primaryStyle)
                                        .font(.custom("Georgia", size: 16).bold())
                                        .foregroundColor(theme.accent)
                                    
                                    Text(report.cognitiveStyle.description)
                                        .font(.custom("Georgia", size: 11))
                                        .foregroundColor(AppColors.mograWhite.opacity(0.65))
                                        .multilineTextAlignment(.center)
                                    
                                    VStack(spacing: 4) {
                                        traitBar("Analytical", report.cognitiveStyle.analyticalScore, theme)
                                        traitBar("Intuitive", report.cognitiveStyle.intuitivScore, theme)
                                        traitBar("Convergent", report.cognitiveStyle.convergentScore, theme)
                                        traitBar("Divergent", report.cognitiveStyle.divergentScore, theme)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity)
                                .glassCard(cornerRadius: 14)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                                
                                // Color Psychology
                                VStack(spacing: 10) {
                                    sectionHeader(icon: "paintpalette.fill", title: "Color Psychology", theme: theme)
                                    
                                    HStack(spacing: 16) {
                                        colorTag(report.colorPsychology.temperament, icon: "thermometer.medium", theme: theme)
                                        colorTag(report.colorPsychology.energyLevel, icon: "bolt.fill", theme: theme)
                                    }
                                    
                                    Text(report.colorPsychology.dominantEmotion)
                                        .font(.custom("Georgia", size: 14).bold())
                                        .foregroundColor(theme.accent)
                                    
                                    Text(report.colorPsychology.description)
                                        .font(.custom("Georgia", size: 11))
                                        .foregroundColor(AppColors.mograWhite.opacity(0.65))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity)
                                .glassCard(cornerRadius: 14)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                                
                                // Creative Profile (Torrance)
                                VStack(spacing: 10) {
                                    sectionHeader(icon: report.creativeProfile.icon, title: "Creative Profile", theme: theme)
                                    
                                    Text(report.creativeProfile.creativeType)
                                        .font(.custom("Georgia", size: 16).bold())
                                        .foregroundColor(theme.accent)
                                    
                                    VStack(spacing: 4) {
                                        traitBar("Fluency", report.creativeProfile.fluency, theme)
                                        traitBar("Flexibility", report.creativeProfile.flexibility, theme)
                                        traitBar("Originality", report.creativeProfile.originality, theme)
                                        traitBar("Elaboration", report.creativeProfile.elaboration, theme)
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity)
                                .glassCard(cornerRadius: 14)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                                
                                // Summary
                                VStack(spacing: 8) {
                                    sectionHeader(icon: "text.quote", title: "Overall Insight", theme: theme)
                                    
                                    Text(report.detailedInsight)
                                        .font(.custom("Georgia", size: 12))
                                        .foregroundColor(AppColors.mograWhite.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(14)
                                .frame(maxWidth: .infinity)
                                .glassCard(cornerRadius: 14)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                            
                            // Did You Know — from FactsLibrary
                            didYouKnowCard(fact: FactsLibrary.randomFact(for: .mandala), theme: theme)
                            didYouKnowCard(fact: FactsLibrary.randomFact(for: .art), theme: theme)

                            // Spirit Card
                            VStack(spacing: 6) {
                                Image(systemName: insight.spirit.icon)
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundColor(theme.accent)
                                Text(insight.spirit.artForm)
                                    .font(.custom("Georgia", size: 16).bold())
                                    .foregroundColor(theme.accent)
                                Text(insight.spirit.description)
                                    .font(.custom("Georgia", size: 11))
                                    .foregroundColor(AppColors.mograWhite.opacity(0.6))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity)
                            .glassCard(cornerRadius: 14)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))

                            // Did You Know — Spirit
                            didYouKnowCard(fact: insight.spirit.fact, theme: theme)
                        }

                        RajButton("Return to Canvas", icon: "paintbrush.fill", color: theme.accent) {
                            gameState.navigate(to: .game)
                        }
                        RajButton("Main Menu", icon: "house", color: AppColors.indigo) {
                            gameState.navigate(to: .menu)
                        }
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, isCompact ? 14 : 20)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) { animateRadar = true }
            withAnimation(.easeOut(duration: 0.6).delay(0.4)) { showContent = true }
        }
    }
    
    // MARK: - Section Header
    private func sectionHeader(icon: String, title: String, theme: CityTheme) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(theme.accent)
            Text(title.uppercased())
                .font(.custom("Georgia", size: 12).bold())
                .foregroundColor(theme.accent)
                .kerning(1.0)
        }
    }
    
    // MARK: - Color Tag
    private func colorTag(_ label: String, icon: String, theme: CityTheme) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundColor(theme.accent)
            Text(label)
                .font(.custom("Georgia", size: 11).bold())
                .foregroundColor(AppColors.mograWhite)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Capsule().fill(theme.accent.opacity(0.12)))
    }
    
    // MARK: - Did You Know Card
    private func didYouKnowCard(fact: String, theme: CityTheme) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(AppColors.saffron)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("DID YOU KNOW?")
                    .font(.custom("Georgia", size: 10).bold())
                    .foregroundColor(AppColors.saffron)
                    .kerning(1.5)
                
                Text(fact)
                    .font(.custom("Georgia", size: 12))
                    .foregroundColor(AppColors.mograWhite.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppColors.saffron.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(AppColors.saffron.opacity(0.2), lineWidth: 1)
        )
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
    
    // MARK: - Trait Bar
    private func traitBar(_ label: String, _ value: Double, _ theme: CityTheme) -> some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.custom("Georgia", size: 9))
                .foregroundColor(AppColors.mograWhite.opacity(0.5))
                .frame(width: 70, alignment: .trailing)
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.08))
                    Capsule()
                        .fill(LinearGradient(colors: [theme.accent.opacity(0.6), theme.accent], startPoint: .leading, endPoint: .trailing))
                        .frame(width: g.size.width * CGFloat(value))
                }
            }
            .frame(height: 5)
            Text("\(Int(value * 100))%")
                .font(.custom("Georgia", size: 8))
                .foregroundColor(theme.accent.opacity(0.6))
                .frame(width: 28, alignment: .leading)
        }
    }
}

// MARK: - Radar Chart
struct RadarChartView: View {
    let dimensions: [String: Double]
    var color: Color = AppColors.royalGold
    
    var body: some View {
        let keys = Array(dimensions.keys.sorted())
        let values = keys.map { dimensions[$0] ?? 0 }
        let count = keys.count
        
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let maxR = min(geo.size.width, geo.size.height) / 2.6
            
            ZStack {
                ForEach(1..<4) { level in
                    let r = maxR * CGFloat(level) / 3.0
                    Path { path in
                        for i in 0..<count {
                            let a = angleFor(index: i, total: count)
                            let pt = CGPoint(x: center.x + r * cos(a), y: center.y + r * sin(a))
                            i == 0 ? path.move(to: pt) : path.addLine(to: pt)
                        }
                        path.closeSubpath()
                    }
                    .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                }
                
                Path { path in
                    for (i, val) in values.enumerated() {
                        let a = angleFor(index: i, total: count)
                        let r = maxR * CGFloat(val)
                        let pt = CGPoint(x: center.x + r * cos(a), y: center.y + r * sin(a))
                        i == 0 ? path.move(to: pt) : path.addLine(to: pt)
                    }
                    path.closeSubpath()
                }
                .fill(color.opacity(0.15))
                
                Path { path in
                    for (i, val) in values.enumerated() {
                        let a = angleFor(index: i, total: count)
                        let r = maxR * CGFloat(val)
                        let pt = CGPoint(x: center.x + r * cos(a), y: center.y + r * sin(a))
                        i == 0 ? path.move(to: pt) : path.addLine(to: pt)
                    }
                    path.closeSubpath()
                }
                .stroke(color, lineWidth: 1.5)
                
                ForEach(0..<count, id: \.self) { i in
                    let a = angleFor(index: i, total: count)
                    let val = values[i]
                    Circle()
                        .fill(color)
                        .frame(width: 5, height: 5)
                        .position(x: center.x + maxR * CGFloat(val) * cos(a),
                                  y: center.y + maxR * CGFloat(val) * sin(a))
                    
                    Text(keys[i])
                        .font(.custom("Georgia", size: 8))
                        .foregroundColor(AppColors.mograWhite.opacity(0.6))
                        .position(
                            x: center.x + (maxR + 18) * cos(a),
                            y: center.y + (maxR + 18) * sin(a)
                        )
                }
            }
        }
    }
    
    private func angleFor(index: Int, total: Int) -> CGFloat {
        -.pi / 2 + (2 * .pi / CGFloat(total)) * CGFloat(index)
    }
}
