import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var gameState: GameState
    @State private var selectedSnapshot: MandalaSnapshot? = nil
    @State private var snapshotToDelete: MandalaSnapshot? = nil
    @State private var showDeleteAlert = false
    
    var body: some View {
        let theme = gameState.activeTheme
        
        ZStack {
            ThemedBackground(theme: theme)
            
            GeometryReader { geo in
                let isCompact = geo.size.width < 400
                let cols = isCompact ? 2 : 3
                let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: cols)
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 4) {
                        Image(systemName: "rectangle.stack.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(theme.accent)
                        Text("GALLERY")
                            .font(.custom("Georgia", size: isCompact ? 28 : 36).bold())
                            .foregroundColor(AppColors.mograWhite)
                            .kerning(3)
                        Text("Your Mandala Journey")
                            .font(.custom("Georgia", size: 11).italic())
                            .foregroundColor(theme.accent.opacity(0.5))
                        
                        // Stats bar
                        if !gameState.savedMandalas.isEmpty {
                            HStack(spacing: 16) {
                                statChip(icon: "photo.stack", value: "\(gameState.savedMandalas.count)", label: "Mandalas")
                                if let avg = averageScore() {
                                    statChip(icon: "chart.bar.fill", value: "\(avg)%", label: "Avg Score")
                                }
                                if let top = topMood() {
                                    statChip(icon: "brain.head.profile", value: top, label: "Top Mood")
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 12)
                    
                    if gameState.savedMandalas.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundColor(theme.accent.opacity(0.2))
                            Text("Your gallery is empty")
                                .font(.custom("Georgia", size: 18).bold())
                                .foregroundColor(AppColors.mograWhite.opacity(0.5))
                            Text("Create your first mandala and save it\nto see your personality insights here.")
                                .font(.custom("Georgia", size: 13))
                                .foregroundColor(AppColors.mograWhite.opacity(0.3))
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(gameState.savedMandalas.reversed()) { snapshot in
                                    MandalaThumbnail(snapshot: snapshot, theme: theme, isCompact: isCompact) {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            selectedSnapshot = snapshot
                                        }
                                        HapticManager.shared.toolSwitch()
                                    } onDelete: {
                                        snapshotToDelete = snapshot
                                        showDeleteAlert = true
                                        HapticManager.shared.erase()
                                    }
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.bottom, 80)
                        }
                    }
                    
                    RajButton("BACK", icon: "arrow.left", color: theme.accent) {
                        gameState.navigate(to: .menu)
                    }
                    .padding(.bottom, 20)
                }
            }
            
            if let snapshot = selectedSnapshot {
                ReportOverlay(snapshot: snapshot, theme: gameState.activeTheme) {
                    withAnimation(.easeInOut(duration: 0.25)) { selectedSnapshot = nil }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: selectedSnapshot?.id)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Mandala"),
                message: Text("Are you sure you want to delete this mandala from your gallery? This cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    if let snapshot = snapshotToDelete {
                        withAnimation {
                            gameState.deleteSnapshot(id: snapshot.id)
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: - Helpers
    
    private func statChip(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundColor(gameState.activeTheme.accent)
                Text(value)
                    .font(.custom("Georgia", size: 12).bold())
                    .foregroundColor(AppColors.mograWhite)
            }
            Text(label)
                .font(.custom("Georgia", size: 8))
                .foregroundColor(AppColors.mograWhite.opacity(0.4))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.white.opacity(0.05))
        )
    }
    
    private func averageScore() -> Int? {
        guard !gameState.savedMandalas.isEmpty else { return nil }
        let total = gameState.savedMandalas.reduce(0) { $0 + $1.score }
        return total / gameState.savedMandalas.count
    }
    
    private func topMood() -> String? {
        let moods = gameState.savedMandalas.map { $0.moodTag }
        let counts = Dictionary(grouping: moods, by: { $0 }).mapValues { $0.count }
        return counts.max(by: { $0.value < $1.value })?.key
    }
}

// MARK: - Thumbnail

struct MandalaThumbnail: View {
    let snapshot: MandalaSnapshot
    let theme: CityTheme
    let isCompact: Bool
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Image
            ZStack {
                if let image = UIImage(contentsOfFile: snapshot.imageURL.path) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: isCompact ? 110 : 140)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(theme.bgColor.opacity(0.3))
                        .frame(height: isCompact ? 110 : 140)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.15))
                        )
                }
                
                // Score badge
                VStack {
                    HStack {
                        Spacer()
                        Text("\(snapshot.score)%")
                            .font(.custom("Georgia", size: 11).bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(theme.accent.opacity(0.85)))
                    }
                    .padding(6)
                    Spacer()
                }
            }
            
            // Info bar
            HStack(spacing: 4) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(snapshot.moodTag)
                        .font(.custom("Georgia", size: isCompact ? 9 : 10).bold())
                        .foregroundColor(theme.accent)
                        .lineLimit(1)
                    Text(snapshot.date, style: .date)
                        .font(.custom("Georgia", size: 8))
                        .foregroundColor(AppColors.mograWhite.opacity(0.4))
                }
                Spacer()
                if snapshot.personalityReport != nil {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 10))
                        .foregroundColor(theme.accent.opacity(0.5))
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 5)
            .background(Color.black.opacity(0.4))
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(theme.accent.opacity(0.12), lineWidth: 1)
        )
        .onTapGesture(perform: onTap)
        .onLongPressGesture(perform: onDelete)
    }
}

// MARK: - Full Report Overlay

struct ReportOverlay: View {
    let snapshot: MandalaSnapshot
    let theme: CityTheme
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            GeometryReader { geo in
                let isCompact = geo.size.width < 420
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Close button
                        HStack {
                            Spacer()
                            Button(action: onDismiss) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                        
                        // Header with image
                        HStack(spacing: 14) {
                            if let image = UIImage(contentsOfFile: snapshot.imageURL.path) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: isCompact ? 80 : 110, height: isCompact ? 80 : 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(snapshot.moodTag)
                                    .font(.custom("Georgia", size: isCompact ? 18 : 22).bold())
                                    .foregroundColor(theme.accent)
                                Text(snapshot.date, style: .date)
                                    .font(.custom("Georgia", size: 11))
                                    .foregroundColor(AppColors.mograWhite.opacity(0.4))
                                HStack(spacing: 2) {
                                    Text("Harmony:")
                                        .font(.custom("Georgia", size: 11))
                                        .foregroundColor(AppColors.mograWhite.opacity(0.5))
                                    Text("\(snapshot.score)%")
                                        .font(.custom("Georgia", size: 16).bold())
                                        .foregroundColor(theme.accent)
                                }
                            }
                            Spacer()
                        }
                        .padding(14)
                        .glassCard(cornerRadius: 14)
                        
                        if let report = snapshot.personalityReport {
                            // ======= YOUR REPORT =======
                            Text("YOUR REPORT")
                                .font(.custom("Georgia", size: 12).bold())
                                .foregroundColor(theme.accent)
                                .kerning(2)
                                .padding(.top, 4)
                            
                            // Plain-language summary
                            VStack(spacing: 8) {
                                reportIcon("text.quote")
                                Text(report.summary)
                                    .font(.custom("Georgia", size: 13))
                                    .foregroundColor(AppColors.mograWhite.opacity(0.75))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity)
                            .glassCard(cornerRadius: 14)
                            
                            // Personality (Big Five) — Plain Language
                            reportCard(
                                title: "Personality",
                                icon: "person.fill",
                                headline: report.bigFive.dominantTrait,
                                body: report.bigFive.description,
                                bars: [
                                    ("Openness", report.bigFive.openness, explainOpenness(report.bigFive.openness)),
                                    ("Conscientious", report.bigFive.conscientiousness, explainConscientiousness(report.bigFive.conscientiousness)),
                                    ("Extraversion", report.bigFive.extraversion, explainExtraversion(report.bigFive.extraversion)),
                                    ("Agreeableness", report.bigFive.agreeableness, explainAgreeableness(report.bigFive.agreeableness)),
                                    ("Stability", 1.0 - report.bigFive.neuroticism, explainStability(1.0 - report.bigFive.neuroticism))
                                ]
                            )
                            
                            // Cognitive Style — Plain Language
                            reportCard(
                                title: "How You Think",
                                icon: report.cognitiveStyle.icon,
                                headline: report.cognitiveStyle.primaryStyle,
                                body: report.cognitiveStyle.description,
                                bars: [
                                    ("Analytical", report.cognitiveStyle.analyticalScore, "Logical, step-by-step reasoning"),
                                    ("Intuitive", report.cognitiveStyle.intuitivScore, "Gut-feeling, pattern-sensing"),
                                    ("Convergent", report.cognitiveStyle.convergentScore, "Focused on the best answer"),
                                    ("Divergent", report.cognitiveStyle.divergentScore, "Exploring many possibilities")
                                ]
                            )
                            
                            // Color Psychology — Plain Language
                            VStack(spacing: 10) {
                                reportSectionHeader(icon: "paintpalette.fill", title: "Your Colors Say")
                                
                                HStack(spacing: 12) {
                                    colorBadge(label: report.colorPsychology.temperament, icon: "thermometer.medium")
                                    colorBadge(label: report.colorPsychology.energyLevel + " Energy", icon: "bolt.fill")
                                }
                                
                                Text(report.colorPsychology.dominantEmotion)
                                    .font(.custom("Georgia", size: 14).bold())
                                    .foregroundColor(theme.accent)
                                
                                Text(report.colorPsychology.description)
                                    .font(.custom("Georgia", size: 11))
                                    .foregroundColor(AppColors.mograWhite.opacity(0.65))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                // What your colors mean
                                VStack(alignment: .leading, spacing: 4) {
                                    colorMeaning("Warm colors", "= energy, passion, optimism")
                                    colorMeaning("Cool colors", "= calm, depth, reflection")
                                    colorMeaning("Mixed palette", "= emotional maturity, balance")
                                }
                                .padding(.top, 4)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity)
                            .glassCard(cornerRadius: 14)
                            
                            // Creative Profile — Plain Language
                            reportCard(
                                title: "Your Creativity",
                                icon: report.creativeProfile.icon,
                                headline: report.creativeProfile.creativeType,
                                body: explainCreativeType(report.creativeProfile.creativeType),
                                bars: [
                                    ("Fluency", report.creativeProfile.fluency, "How quickly you generate ideas"),
                                    ("Flexibility", report.creativeProfile.flexibility, "Range of approaches you use"),
                                    ("Originality", report.creativeProfile.originality, "How unique your combinations are"),
                                    ("Elaboration", report.creativeProfile.elaboration, "Level of detail and refinement")
                                ]
                            )
                            
                            // Detailed Insight
                            VStack(spacing: 8) {
                                reportSectionHeader(icon: "sparkles", title: "Deep Insight")
                                Text(report.detailedInsight)
                                    .font(.custom("Georgia", size: 12))
                                    .foregroundColor(AppColors.mograWhite.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity)
                            .glassCard(cornerRadius: 14)
                            
                        } else {
                            // No report
                            VStack(spacing: 8) {
                                Image(systemName: "brain")
                                    .font(.system(size: 32))
                                    .foregroundColor(theme.accent.opacity(0.3))
                                Text("No personality report available")
                                    .font(.custom("Georgia", size: 14))
                                    .foregroundColor(AppColors.mograWhite.opacity(0.4))
                                Text("This mandala was saved before personality analysis was added.")
                                    .font(.custom("Georgia", size: 11))
                                    .foregroundColor(AppColors.mograWhite.opacity(0.3))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(20)
                            .glassCard(cornerRadius: 14)
                        }
                        
                        // Close / Share
                        VStack(spacing: 12) {
                            Button(action: {
                                ShareManager.shared.shareMandala(snapshot: snapshot, from: getRootViewController())
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share My Mandala")
                                        .font(.custom("Georgia", size: 14).bold())
                                }
                                .foregroundColor(theme.accent)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(Capsule().fill(.ultraThinMaterial))
                                .overlay(Capsule().stroke(theme.accent.opacity(0.3), lineWidth: 1.5))
                            }
                            
                            Button(action: onDismiss) {
                                Text("Close Report")
                                    .font(.custom("Georgia", size: 14).bold())
                                    .foregroundColor(theme.accent)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 10)
                                    .background(Capsule().stroke(theme.accent, lineWidth: 1.5))
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    .padding(.horizontal, isCompact ? 14 : 24)
                }
                .frame(maxWidth: 520)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    // MARK: - Report Card (reusable)
    
    private func reportCard(title: String, icon: String, headline: String, body: String, bars: [(String, Double, String)]) -> some View {
        VStack(spacing: 10) {
            reportSectionHeader(icon: icon, title: title)
            
            Text(headline)
                .font(.custom("Georgia", size: 16).bold())
                .foregroundColor(theme.accent)
            
            Text(body)
                .font(.custom("Georgia", size: 11))
                .foregroundColor(AppColors.mograWhite.opacity(0.65))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: 6) {
                ForEach(bars, id: \.0) { label, value, explanation in
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text(label)
                                .font(.custom("Georgia", size: 9).bold())
                                .foregroundColor(AppColors.mograWhite.opacity(0.6))
                                .frame(width: 80, alignment: .trailing)
                            GeometryReader { g in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color.white.opacity(0.08))
                                    Capsule()
                                        .fill(LinearGradient(colors: [theme.accent.opacity(0.5), theme.accent], startPoint: .leading, endPoint: .trailing))
                                        .frame(width: g.size.width * CGFloat(value))
                                }
                            }
                            .frame(height: 5)
                            Text("\(Int(value * 100))%")
                                .font(.custom("Georgia", size: 8).bold())
                                .foregroundColor(theme.accent.opacity(0.7))
                                .frame(width: 28, alignment: .leading)
                        }
                        Text(explanation)
                            .font(.custom("Georgia", size: 8))
                            .foregroundColor(AppColors.mograWhite.opacity(0.35))
                            .padding(.leading, 84)
                    }
                }
            }
            .padding(.top, 4)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: 14)
    }
    
    private func reportSectionHeader(icon: String, title: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(theme.accent)
            Text(title.uppercased())
                .font(.custom("Georgia", size: 11).bold())
                .foregroundColor(theme.accent)
                .kerning(1.0)
        }
    }
    
    private func reportIcon(_ name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(theme.accent)
    }
    
    private func colorBadge(label: String, icon: String) -> some View {
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
    
    private func colorMeaning(_ key: String, _ desc: String) -> some View {
        HStack(spacing: 4) {
            Text(key)
                .font(.custom("Georgia", size: 9).bold())
                .foregroundColor(theme.accent.opacity(0.7))
            Text(desc)
                .font(.custom("Georgia", size: 9))
                .foregroundColor(AppColors.mograWhite.opacity(0.4))
        }
    }
    
    // MARK: - Plain Language Explanations
    
    private func explainOpenness(_ v: Double) -> String {
        v > 0.6 ? "You love exploring new ideas" : "You prefer tried-and-true approaches"
    }
    private func explainConscientiousness(_ v: Double) -> String {
        v > 0.6 ? "Very organized and methodical" : "Spontaneous and flexible"
    }
    private func explainExtraversion(_ v: Double) -> String {
        v > 0.6 ? "Energetic and bold" : "Thoughtful and reserved"
    }
    private func explainAgreeableness(_ v: Double) -> String {
        v > 0.6 ? "Harmony-seeking and cooperative" : "Independent and decisive"
    }
    private func explainStability(_ v: Double) -> String {
        v > 0.6 ? "Calm and emotionally resilient" : "Sensitive and passionate"
    }
    private func explainCreativeType(_ type: String) -> String {
        switch type {
        case "Renaissance Creator": return "You combine productivity with versatility — the rare mind that does it all. You move between ideas fluently and bring each to high detail."
        case "Visionary Innovator": return "Your strength is in unique, unexpected combinations. You see possibilities others miss and aren't afraid to break the mold."
        case "Master Craftsperson": return "You excel at refining and perfecting. Where others rush, you take your time to make every detail count."
        case "Prolific Producer": return "You generate ideas at remarkable speed. Your creative energy is prolific — you'd rather create many pieces than agonize over one."
        case "Versatile Explorer": return "Your creativity lies in variety. You love trying different approaches and never settle into a single style."
        default: return "Your creative voice is developing. Every mandala you create reveals more about your unique artistic spirit."
        }
    }
}
