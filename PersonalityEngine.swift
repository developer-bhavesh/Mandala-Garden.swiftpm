import Foundation
import NaturalLanguage

// MARK: - Personality Report (Codable for saving)

struct PersonalityReport: Codable {
    let bigFive: BigFiveTraits
    let cognitiveStyle: CognitiveStyle
    let colorPsychology: ColorPsychologyProfile
    let creativeProfile: CreativeProfile
    let summary: String
    let detailedInsight: String
}

// MARK: - Big Five Personality Traits

struct BigFiveTraits: Codable {
    let openness: Double        // 0-1: Creativity, curiosity, variety-seeking
    let conscientiousness: Double // 0-1: Organization, methodical approach
    let extraversion: Double     // 0-1: Boldness, energy, warmth
    let agreeableness: Double    // 0-1: Harmony, cooperation, balance
    let neuroticism: Double      // 0-1 (inverted: emotional stability)
    
    var dominantTrait: String {
        let traits: [(String, Double)] = [
            ("Openness", openness),
            ("Conscientiousness", conscientiousness),
            ("Extraversion", extraversion),
            ("Agreeableness", agreeableness),
            ("Emotional Stability", 1.0 - neuroticism)
        ]
        return traits.max(by: { $0.1 < $1.1 })?.0 ?? "Balanced"
    }
    
    var description: String {
        switch dominantTrait {
        case "Openness":
            return "You embrace creativity and novelty. Your mandala reflects a mind open to new experiences and unafraid of unconventional choices."
        case "Conscientiousness":
            return "You value precision and order. Your mandala shows a disciplined mind that finds beauty in structure and careful planning."
        case "Extraversion":
            return "You radiate warmth and energy. Your mandala is bold and expressive, reflecting an outgoing spirit that draws others in."
        case "Agreeableness":
            return "You seek harmony in all things. Your balanced mandala reflects a cooperative nature that values peaceful coexistence."
        case "Emotional Stability":
            return "You are calm and composed. Your steady mandala patterns reveal an emotionally resilient mind."
        default:
            return "Your personality shows a beautiful balance across all dimensions."
        }
    }
}

// MARK: - Cognitive Style

struct CognitiveStyle: Codable {
    let analyticalScore: Double   // Preference for logic, pattern, structure
    let intuitivScore: Double     // Preference for feeling, gestalt, big picture
    let convergentScore: Double   // Focus on one correct answer / consistency
    let divergentScore: Double    // Multiple solutions / variety
    
    var primaryStyle: String {
        let styles: [(String, Double)] = [
            ("Analytical", analyticalScore),
            ("Intuitive", intuitivScore),
            ("Convergent", convergentScore),
            ("Divergent", divergentScore)
        ]
        return styles.max(by: { $0.1 < $1.1 })?.0 ?? "Balanced"
    }
    
    var icon: String {
        switch primaryStyle {
        case "Analytical": return "brain.head.profile"
        case "Intuitive": return "eye.fill"
        case "Convergent": return "arrow.triangle.merge"
        case "Divergent": return "arrow.triangle.branch"
        default: return "circle.hexagongrid.fill"
        }
    }
    
    var description: String {
        switch primaryStyle {
        case "Analytical":
            return "Your thinking is systematic and logical. You approach problems methodically, preferring structure and evidence-based decisions."
        case "Intuitive":
            return "You think in patterns and feelings. Your decisions are guided by gut instinct and holistic understanding."
        case "Convergent":
            return "You focus deeply on perfecting one approach. Your mind gravitates toward finding the single best solution."
        case "Divergent":
            return "Your mind explores multiple possibilities simultaneously. You naturally generate creative alternatives and novel combinations."
        default:
            return "Your cognitive approach is well-rounded, blending analysis with intuition."
        }
    }
}

// MARK: - Color Psychology Profile

struct ColorPsychologyProfile: Codable {
    let dominantEmotion: String
    let energyLevel: String         // Low, Medium, High
    let temperament: String         // Warm, Cool, Balanced
    let emotionalValence: Double    // -1 to 1 (negative to positive)
    let arousalLevel: Double        // 0-1 (calm to excited)
    let description: String
}

// MARK: - Creative Profile

struct CreativeProfile: Codable {
    let fluency: Double         // How many ideas (slot fill rate)
    let flexibility: Double     // Variety of approaches (flower types)
    let originality: Double     // Unusual combinations
    let elaboration: Double     // Detail and refinement (tints, shapes)
    
    var creativeType: String {
        if fluency > 0.7 && flexibility > 0.7 { return "Renaissance Creator" }
        if originality > 0.7 { return "Visionary Innovator" }
        if elaboration > 0.7 { return "Master Craftsperson" }
        if fluency > 0.7 { return "Prolific Producer" }
        if flexibility > 0.7 { return "Versatile Explorer" }
        return "Emerging Artist"
    }
    
    var icon: String {
        switch creativeType {
        case "Renaissance Creator": return "star.fill"
        case "Visionary Innovator": return "lightbulb.fill"
        case "Master Craftsperson": return "hammer.fill"
        case "Prolific Producer": return "bolt.fill"
        case "Versatile Explorer": return "safari.fill"
        default: return "paintbrush.fill"
        }
    }
}

// MARK: - Personality Engine

class PersonalityEngine {
    
    /// Color psychology mapping based on Lüscher Color Test and research
    private static let colorTraits: [String: (warmth: Double, energy: Double, emotion: String, valence: Double, arousal: Double)] = [
        "Lotus": (0.3, 0.4, "Purity & Spiritual Growth", 0.7, 0.3),
        "Marigold": (0.9, 0.8, "Joy & Celebration", 0.9, 0.7),
        "Rose": (0.7, 0.5, "Love & Compassion", 0.8, 0.5),
        "Jasmine": (0.4, 0.3, "Peace & Innocence", 0.6, 0.2),
        "Hibiscus": (0.8, 0.7, "Passion & Vitality", 0.6, 0.8),
        "Sunflower": (0.9, 0.9, "Optimism & Confidence", 0.9, 0.8),
        "Champa": (0.5, 0.4, "Devotion & Sincerity", 0.5, 0.3),
        "Dahlia": (0.6, 0.6, "Elegance & Creativity", 0.7, 0.6)
    ]
    
    /// Theme background warmth mapping
    private static let themeWarmth: [String: (warmth: Double, mood: String)] = [
        "jaipur": (0.8, "warm and majestic"),
        "jodhpur": (0.3, "cool and meditative"),
        "udaipur": (0.4, "serene and romantic"),
        "jaisalmer": (0.9, "golden and bold"),
        "bikaner": (0.7, "earthy and grounded"),
        "pushkar": (0.5, "spiritual and balanced"),
        "chittorgarh": (0.6, "heroic and regal")
    ]
    
    static func analyze(
        slots: [HarmonyScorer.MandalaSlotData],
        undoCount: Int,
        flowerChanges: Int,
        sessionDuration: TimeInterval,
        slotsFilledCount: Int,
        slotsErasedCount: Int,
        themeKey: String = "jaipur"
    ) -> PersonalityReport {
        let occupied = slots.filter { $0.flower != nil }
        let total = max(slots.count, 1)
        let completeness = Double(occupied.count) / Double(total)
        let maxRing = slots.map { $0.ring }.max() ?? 1
        
        // Flower type distribution
        let flowerTypes = occupied.compactMap { $0.flower?.type.rawValue }
        let uniqueTypes = Set(flowerTypes)
        let typeVariety = Double(uniqueTypes.count) / max(Double(8), 1.0) // Out of 8 total types
        
        // Symmetry calculation
        var symPoints = 0.0
        var ringCount = 0
        for ring in 0...maxRing {
            let rs = slots.filter { $0.ring == ring }
            let variants = Set(rs.compactMap { $0.flower?.type.rawValue })
            if variants.count == 1 && rs.allSatisfy({ $0.flower != nil }) {
                symPoints += 1.0
            } else if !variants.isEmpty {
                symPoints += 0.3
            }
            ringCount += 1
        }
        let symmetry = symPoints / Double(max(ringCount, 1))
        
        // Tint usage
        let tintedCount = occupied.filter { $0.tint != .natural }.count
        let tintUsage = Double(tintedCount) / Double(max(occupied.count, 1))
        
        // Shannon entropy of flower distribution (measures disorder/variety)
        var entropy = 0.0
        let flowerCounts = Dictionary(grouping: flowerTypes, by: { $0 }).mapValues { $0.count }
        let n = Double(flowerTypes.count)
        if n > 0 {
            for (_, count) in flowerCounts {
                let p = Double(count) / n
                if p > 0 { entropy -= p * log2(p) }
            }
        }
        let maxEntropy = log2(max(Double(uniqueTypes.count), 1))
        let normalizedEntropy = maxEntropy > 0 ? entropy / maxEntropy : 0
        
        // Behavioral analysis
        let decisionRate = sessionDuration > 0 ? Double(slotsFilledCount) / (sessionDuration / 60.0) : 0
        let undoRatio = slotsFilledCount > 0 ? Double(undoCount) / Double(slotsFilledCount) : 0
        let eraseRatio = slotsFilledCount > 0 ? Double(slotsErasedCount) / Double(slotsFilledCount) : 0
        
        // === Big Five Personality Traits ===
        let themeBgWarmth = themeWarmth[themeKey]?.warmth ?? 0.5
        let bigFive = computeBigFive(
            symmetry: symmetry, typeVariety: typeVariety, completeness: completeness,
            entropy: normalizedEntropy, tintUsage: tintUsage, undoRatio: undoRatio,
            warmth: computeWarmth(occupied), eraseRatio: eraseRatio, decisionRate: decisionRate,
            bgWarmth: themeBgWarmth
        )
        
        // === Cognitive Style ===
        let cognitive = computeCognitiveStyle(
            symmetry: symmetry, entropy: normalizedEntropy, typeVariety: typeVariety,
            undoRatio: undoRatio, completeness: completeness, decisionRate: decisionRate
        )
        
        // === Color Psychology ===
        let colorProfile = computeColorPsychology(occupied)
        
        // === Creative Profile ===
        let creative = computeCreativeProfile(
            completeness: completeness, typeVariety: typeVariety,
            entropy: normalizedEntropy, tintUsage: tintUsage, flowerChanges: flowerChanges,
            totalSlots: total
        )
        
        // === Summary Generation ===
        let summary = generateSummary(bigFive: bigFive, cognitive: cognitive, creative: creative)
        let themeMood = themeWarmth[themeKey]?.mood ?? "balanced"
        let detailed = generateDetailedInsight(
            bigFive: bigFive, cognitive: cognitive, colorProfile: colorProfile,
            creative: creative, symmetry: symmetry, completeness: completeness,
            themeMood: themeMood
        )
        
        return PersonalityReport(
            bigFive: bigFive,
            cognitiveStyle: cognitive,
            colorPsychology: colorProfile,
            creativeProfile: creative,
            summary: summary,
            detailedInsight: detailed
        )
    }
    
    // MARK: - Big Five Computation
    
    private static func computeBigFive(
        symmetry: Double, typeVariety: Double, completeness: Double,
        entropy: Double, tintUsage: Double, undoRatio: Double,
        warmth: Double, eraseRatio: Double, decisionRate: Double,
        bgWarmth: Double = 0.5
    ) -> BigFiveTraits {
        // Blend flower warmth with theme bg warmth (70/30 split)
        let blendedWarmth = warmth * 0.7 + bgWarmth * 0.3
        // Openness: High variety, tint usage, low symmetry = openness to new experiences
        let openness = clamp(typeVariety * 0.35 + entropy * 0.25 + tintUsage * 0.2 + (1.0 - symmetry) * 0.2)
        
        // Conscientiousness: High symmetry, high completeness, low undo = organized
        let conscientiousness = clamp(symmetry * 0.4 + completeness * 0.35 + (1.0 - undoRatio) * 0.25)
        
        // Extraversion: Warm colors + warm theme bg, high fill rate, bold choices
        let extraversion = clamp(blendedWarmth * 0.35 + min(decisionRate / 10.0, 1.0) * 0.3 + completeness * 0.2 + typeVariety * 0.15)
        
        // Agreeableness: Balanced patterns, cool themes boost harmony
        let balance = 1.0 - abs(symmetry - 0.5) * 2.0
        let coolBonus = (1.0 - bgWarmth) * 0.1
        let agreeableness = clamp(balance * 0.3 + (1.0 - eraseRatio) * 0.25 + completeness * 0.2 + symmetry * 0.15 + coolBonus)
        
        // Neuroticism: High undo, high erase, indecisiveness
        let neuroticism = clamp(undoRatio * 0.4 + eraseRatio * 0.3 + (1.0 - completeness) * 0.2 + (1.0 - symmetry) * 0.1)
        
        return BigFiveTraits(
            openness: openness,
            conscientiousness: conscientiousness,
            extraversion: extraversion,
            agreeableness: agreeableness,
            neuroticism: neuroticism
        )
    }
    
    // MARK: - Cognitive Style
    
    private static func computeCognitiveStyle(
        symmetry: Double, entropy: Double, typeVariety: Double,
        undoRatio: Double, completeness: Double, decisionRate: Double
    ) -> CognitiveStyle {
        // Analytical: High symmetry + methodical (low undo, high completeness)
        let analytical = clamp(symmetry * 0.4 + completeness * 0.3 + (1.0 - undoRatio) * 0.3)
        
        // Intuitive: Moderate symmetry, fast decisions, less revision
        let intuitive = clamp(min(decisionRate / 8.0, 1.0) * 0.35 + (1.0 - undoRatio) * 0.3 + entropy * 0.2 + (1.0 - symmetry) * 0.15)
        
        // Convergent: Low variety, high symmetry, repetitive
        let convergent = clamp((1.0 - typeVariety) * 0.35 + symmetry * 0.35 + (1.0 - entropy) * 0.3)
        
        // Divergent: High variety, high entropy, many changes
        let divergent = clamp(typeVariety * 0.3 + entropy * 0.3 + min(Double(1), undoRatio * 2.0) * 0.2 + (1.0 - symmetry) * 0.2)
        
        return CognitiveStyle(
            analyticalScore: analytical,
            intuitivScore: intuitive,
            convergentScore: convergent,
            divergentScore: divergent
        )
    }
    
    // MARK: - Color Psychology
    
    private static func computeColorPsychology(_ occupied: [HarmonyScorer.MandalaSlotData]) -> ColorPsychologyProfile {
        guard !occupied.isEmpty else {
            return ColorPsychologyProfile(
                dominantEmotion: "Potential", energyLevel: "Neutral",
                temperament: "Balanced", emotionalValence: 0.0,
                arousalLevel: 0.0, description: "The empty canvas holds infinite possibility."
            )
        }
        
        var totalWarmth = 0.0, totalEnergy = 0.0, totalValence = 0.0, totalArousal = 0.0
        var emotionCounts: [String: Int] = [:]
        
        for slot in occupied {
            guard let name = slot.flower?.type.rawValue,
                  let traits = colorTraits[name] else { continue }
            totalWarmth += traits.warmth
            totalEnergy += traits.energy
            totalValence += traits.valence
            totalArousal += traits.arousal
            emotionCounts[traits.emotion, default: 0] += 1
        }
        
        let n = Double(occupied.count)
        let avgWarmth = totalWarmth / n
        let avgEnergy = totalEnergy / n
        let avgValence = totalValence / n
        let avgArousal = totalArousal / n
        
        let dominantEmotion = emotionCounts.max(by: { $0.value < $1.value })?.key ?? "Balance"
        let energyLevel = avgEnergy > 0.65 ? "High" : avgEnergy > 0.35 ? "Medium" : "Low"
        let temperament = avgWarmth > 0.65 ? "Warm" : avgWarmth < 0.35 ? "Cool" : "Balanced"
        
        var description = ""
        if avgWarmth > 0.7 && avgEnergy > 0.6 {
            description = "Your color choices radiate warmth and vitality. You are drawn to passionate, life-affirming hues that suggest an optimistic and engaging personality."
        } else if avgWarmth < 0.4 && avgEnergy < 0.4 {
            description = "You gravitate toward cool, contemplative tones. This suggests an introspective nature that values depth, calm, and thoughtful reflection."
        } else if avgEnergy > 0.7 {
            description = "High-energy colors dominate your palette, revealing a dynamic personality that thrives on action, excitement, and bold self-expression."
        } else if avgValence > 0.7 {
            description = "Your positive color palette reflects an optimistic worldview. You naturally see beauty and potential in the world around you."
        } else {
            description = "Your balanced color palette shows emotional maturity. You blend warmth with coolness, creating harmony that reflects inner equilibrium."
        }
        
        return ColorPsychologyProfile(
            dominantEmotion: dominantEmotion,
            energyLevel: energyLevel,
            temperament: temperament,
            emotionalValence: avgValence * 2.0 - 1.0, // Map to -1...1
            arousalLevel: avgArousal,
            description: description
        )
    }
    
    // MARK: - Creative Profile
    
    private static func computeCreativeProfile(
        completeness: Double, typeVariety: Double, entropy: Double,
        tintUsage: Double, flowerChanges: Int, totalSlots: Int
    ) -> CreativeProfile {
        let fluency = clamp(completeness)
        let flexibility = clamp(typeVariety * 0.5 + entropy * 0.3 + min(Double(flowerChanges) / 20.0, 1.0) * 0.2)
        let originality = clamp(entropy * 0.4 + tintUsage * 0.3 + typeVariety * 0.3)
        let elaboration = clamp(completeness * 0.3 + tintUsage * 0.3 + typeVariety * 0.2 + (totalSlots > 20 ? 0.2 : 0.1))
        
        return CreativeProfile(
            fluency: fluency, flexibility: flexibility,
            originality: originality, elaboration: elaboration
        )
    }
    
    // MARK: - Warmth Calculation
    
    private static func computeWarmth(_ occupied: [HarmonyScorer.MandalaSlotData]) -> Double {
        guard !occupied.isEmpty else { return 0.5 }
        var total = 0.0
        for slot in occupied {
            if let name = slot.flower?.type.rawValue, let traits = colorTraits[name] {
                total += traits.warmth
            }
        }
        return total / Double(occupied.count)
    }
    
    // MARK: - Summary Generation
    
    private static func generateSummary(bigFive: BigFiveTraits, cognitive: CognitiveStyle, creative: CreativeProfile) -> String {
        return "Your mandala reveals a \(bigFive.dominantTrait.lowercased())-oriented personality with a \(cognitive.primaryStyle.lowercased()) cognitive style. As a \(creative.creativeType), you bring \(bigFive.openness > 0.6 ? "creative exploration" : "focused precision") to your art."
    }
    
    private static func generateDetailedInsight(
        bigFive: BigFiveTraits, cognitive: CognitiveStyle, colorProfile: ColorPsychologyProfile,
        creative: CreativeProfile, symmetry: Double, completeness: Double,
        themeMood: String = "balanced"
    ) -> String {
        var lines: [String] = []
        
        // Personality overview
        lines.append("Your \(bigFive.dominantTrait) is your strongest personality trait, shaping how you approach creative challenges.")
        
        // Cognitive observation
        if cognitive.analyticalScore > 0.6 {
            lines.append("Your analytical mind gravitates toward symmetrical, structured patterns — evidence of systematic thinking.")
        } else if cognitive.divergentScore > 0.6 {
            lines.append("You think divergently, naturally exploring multiple creative directions rather than settling on one approach.")
        }
        
        // Color + theme insight
        lines.append("Your \(colorProfile.temperament.lowercased()) color temperament on a \(themeMood) canvas with \(colorProfile.energyLevel.lowercased()) energy reveals: \(colorProfile.dominantEmotion).")
        
        // Growth area
        if bigFive.openness < 0.4 {
            lines.append("Consider experimenting with more flower varieties to expand your creative range.")
        } else if bigFive.conscientiousness < 0.4 {
            lines.append("Try building complete, symmetrical patterns to develop your organizational instincts.")
        }
        
        return lines.joined(separator: " ")
    }
    
    private static func clamp(_ v: Double) -> Double {
        return max(0, min(1, v))
    }
}
