import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var gameState: GameState
    let columns = [GridItem(.adaptive(minimum: 140), spacing: 14)]
    @State private var selectedSnapshot: MandalaSnapshot? = nil
    
    var body: some View {
        let theme = gameState.activeTheme
        
        ZStack {
            ThemedBackground(theme: theme)
            
            GeometryReader { geo in
                let isCompact = geo.size.width < 400
                
                VStack(spacing: 0) {
                    VStack(spacing: 3) {
                        Text("GALLERY")
                            .font(.custom("Georgia", size: isCompact ? 32 : 40).bold())
                            .foregroundColor(AppColors.mograWhite)
                        Text("Your Mandala Journey")
                            .font(.custom("Georgia", size: 11).italic())
                            .foregroundColor(theme.accent.opacity(0.5))
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 12)
                    
                    if gameState.savedMandalas.isEmpty {
                        Spacer()
                        VStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 32))
                                .foregroundColor(theme.accent.opacity(0.3))
                            Text("Gallery is empty.\nCreate your first mandala!")
                                .font(.custom("Georgia", size: 16).italic())
                                .foregroundColor(AppColors.mograWhite.opacity(0.4))
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 14) {
                                ForEach(gameState.savedMandalas) { snapshot in
                                    MandalaThumbnail(snapshot: snapshot, theme: theme)
                                        .onTapGesture {
                                            selectedSnapshot = snapshot
                                        }
                                }
                            }
                            .padding(.horizontal, 14)
                        }
                    }
                    
                    RajButton("BACK", icon: "arrow.left", color: theme.accent) {
                        gameState.navigate(to: .menu)
                    }
                    .padding(.bottom, 30)
                }
            }
            
            // Report overlay
            if let snapshot = selectedSnapshot {
                ReportOverlay(snapshot: snapshot, theme: gameState.activeTheme) {
                    selectedSnapshot = nil
                }
                .transition(.opacity)
            }
        }
    }
}

// MARK: - Report Overlay (shows saved personality report)
struct ReportOverlay: View {
    let snapshot: MandalaSnapshot
    let theme: CityTheme
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.75).ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(snapshot.moodTag)
                                .font(.custom("Georgia", size: 20).bold())
                                .foregroundColor(theme.accent)
                            Text(snapshot.date, style: .date)
                                .font(.custom("Georgia", size: 11))
                                .foregroundColor(AppColors.mograWhite.opacity(0.5))
                        }
                        Spacer()
                        Text("\(snapshot.score)%")
                            .font(.custom("Georgia", size: 28).bold())
                            .foregroundColor(theme.accent)
                    }
                    .padding(14)
                    .glassCard(cornerRadius: 14)
                    
                    // Mandala image
                    if let image = UIImage(contentsOfFile: snapshot.imageURL.path) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // Personality Report
                    if let report = snapshot.personalityReport {
                        // Big Five
                        reportSection(title: "Personality", icon: "person.fill") {
                            VStack(spacing: 4) {
                                Text(report.bigFive.dominantTrait)
                                    .font(.custom("Georgia", size: 14).bold())
                                    .foregroundColor(theme.accent)
                                reportBar("Open", report.bigFive.openness)
                                reportBar("Conscientious", report.bigFive.conscientiousness)
                                reportBar("Extravert", report.bigFive.extraversion)
                                reportBar("Agreeable", report.bigFive.agreeableness)
                                reportBar("Stability", 1.0 - report.bigFive.neuroticism)
                            }
                        }
                        
                        // Cognitive
                        reportSection(title: "Cognitive Style", icon: report.cognitiveStyle.icon) {
                            VStack(spacing: 4) {
                                Text(report.cognitiveStyle.primaryStyle)
                                    .font(.custom("Georgia", size: 14).bold())
                                    .foregroundColor(theme.accent)
                                reportBar("Analytical", report.cognitiveStyle.analyticalScore)
                                reportBar("Intuitive", report.cognitiveStyle.intuitivScore)
                                reportBar("Convergent", report.cognitiveStyle.convergentScore)
                                reportBar("Divergent", report.cognitiveStyle.divergentScore)
                            }
                        }
                        
                        // Color Psychology
                        reportSection(title: "Color Psychology", icon: "paintpalette.fill") {
                            VStack(spacing: 6) {
                                HStack(spacing: 8) {
                                    capsuleTag(report.colorPsychology.temperament)
                                    capsuleTag(report.colorPsychology.energyLevel)
                                }
                                Text(report.colorPsychology.dominantEmotion)
                                    .font(.custom("Georgia", size: 12).bold())
                                    .foregroundColor(theme.accent)
                                Text(report.colorPsychology.description)
                                    .font(.custom("Georgia", size: 10))
                                    .foregroundColor(AppColors.mograWhite.opacity(0.6))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        // Creative
                        reportSection(title: "Creative Profile", icon: report.creativeProfile.icon) {
                            VStack(spacing: 4) {
                                Text(report.creativeProfile.creativeType)
                                    .font(.custom("Georgia", size: 14).bold())
                                    .foregroundColor(theme.accent)
                                reportBar("Fluency", report.creativeProfile.fluency)
                                reportBar("Flexibility", report.creativeProfile.flexibility)
                                reportBar("Originality", report.creativeProfile.originality)
                                reportBar("Elaboration", report.creativeProfile.elaboration)
                            }
                        }
                        
                        // Summary
                        Text(report.summary)
                            .font(.custom("Georgia", size: 11))
                            .foregroundColor(AppColors.mograWhite.opacity(0.65))
                            .multilineTextAlignment(.center)
                            .padding(12)
                            .glassCard(cornerRadius: 12)
                    } else {
                        Text("No personality report saved for this mandala.")
                            .font(.custom("Georgia", size: 12).italic())
                            .foregroundColor(AppColors.mograWhite.opacity(0.4))
                            .padding()
                    }
                    
                    Button(action: onDismiss) {
                        Text("Close")
                            .font(.custom("Georgia", size: 14).bold())
                            .foregroundColor(theme.accent)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Capsule().stroke(theme.accent, lineWidth: 1.5))
                    }
                    .padding(.bottom, 30)
                }
                .padding(20)
            }
            .frame(maxWidth: 500)
        }
    }
    
    private func reportSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(theme.accent)
                Text(title.uppercased())
                    .font(.custom("Georgia", size: 10).bold())
                    .foregroundColor(theme.accent)
                    .kerning(1.0)
            }
            content()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: 12)
    }
    
    private func reportBar(_ label: String, _ value: Double) -> some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.custom("Georgia", size: 9))
                .foregroundColor(AppColors.mograWhite.opacity(0.5))
                .frame(width: 70, alignment: .trailing)
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.08))
                    Capsule()
                        .fill(theme.accent.opacity(0.7))
                        .frame(width: g.size.width * CGFloat(value))
                }
            }
            .frame(height: 4)
            Text("\(Int(value * 100))%")
                .font(.custom("Georgia", size: 8))
                .foregroundColor(theme.accent.opacity(0.6))
                .frame(width: 28, alignment: .leading)
        }
    }
    
    private func capsuleTag(_ text: String) -> some View {
        Text(text)
            .font(.custom("Georgia", size: 10).bold())
            .foregroundColor(AppColors.mograWhite)
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            .background(Capsule().fill(theme.accent.opacity(0.15)))
    }
}

struct MandalaThumbnail: View {
    let snapshot: MandalaSnapshot
    let theme: CityTheme
    
    var body: some View {
        VStack(spacing: 0) {
            if let image = UIImage(contentsOfFile: snapshot.imageURL.path) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 130)
                    .clipped()
            } else {
                Rectangle()
                    .fill(theme.bgColor.opacity(0.2))
                    .frame(height: 130)
                    .overlay(Image(systemName: "photo").foregroundColor(.white.opacity(0.2)))
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(snapshot.date, style: .date)
                        .font(.custom("Georgia", size: 9))
                        .foregroundColor(AppColors.mograWhite.opacity(0.5))
                    Text(snapshot.moodTag)
                        .font(.custom("Georgia", size: 10).bold())
                        .foregroundColor(theme.accent)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    Text("\(snapshot.score)%")
                        .font(.custom("Georgia", size: 13).bold())
                        .foregroundColor(theme.accent)
                    if snapshot.personalityReport != nil {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 8))
                            .foregroundColor(theme.accent.opacity(0.5))
                    }
                }
            }
            .padding(6)
            .background(Color.black.opacity(0.35))
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }
}
