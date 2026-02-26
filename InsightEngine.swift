import Foundation
import NaturalLanguage

// MARK: - Insight Data Models

enum MandalasMood: String, CaseIterable {
    case calm = "Calm & Centered"
    case energetic = "Energetic & Vibrant"
    case contemplative = "Contemplative & Thoughtful"
    case passionate = "Passionate & Bold"
    case harmonious = "Harmonious & Balanced"
    case chaotic = "Chaotic & Experimental"
    case joyful = "Joyful & Playful"
    case serene = "Serene & Meditative"
    case mystic = "Mystic & Dreamy"
    case grounded = "Grounded & Steady"
    case radiant = "Radiant & Warm"
    case intricate = "Intricate & Detailed"
    
    var icon: String {
        switch self {
        case .calm: return "leaf.fill"
        case .energetic: return "bolt.fill"
        case .contemplative: return "moon.stars.fill"
        case .passionate: return "flame.fill"
        case .harmonious: return "circle.hexagongrid.fill"
        case .chaotic: return "wind"
        case .joyful: return "sun.min.fill"
        case .serene: return "drop.fill"
        case .mystic: return "sparkle"
        case .grounded: return "mountain.2.fill"
        case .radiant: return "sun.max.fill"
        case .intricate: return "square.grid.3x3.fill"
        }
    }
    
    var description: String {
        switch self {
        case .calm: return "Your pattern radiates stillness and peace, like a temple courtyard at dawn."
        case .energetic: return "Your design bursts with vitality — a Rajasthani festival of color!"
        case .contemplative: return "A deeply introspective pattern, reflecting your inner world."
        case .passionate: return "Bold color choices reveal a passionate spirit, like Phad paintings."
        case .harmonious: return "Perfect balance — your mandala echoes Jali geometric precision."
        case .chaotic: return "A fearless explorer! Your pattern breaks conventions."
        case .joyful: return "Your garden sings with delight! Like children playing in the Thar dunes."
        case .serene: return "Still waters of Lake Pichola — your mandala breathes quiet grace."
        case .mystic: return "An enigmatic pattern, like moonlight filtering through Jali screens."
        case .grounded: return "Solid as the Aravalli Range — your mandala has deep roots and quiet strength."
        case .radiant: return "Glowing like the golden sandstone of Jaisalmer at sunset."
        case .intricate: return "Each detail matters — the precision of a Meenakari artisan at work."
        }
    }
    
    var didYouKnow: String {
        // Dynamic fact from FactsLibrary based on mood
        return FactsLibrary.factsForMood(self.rawValue).first ?? "Rajasthan, the Land of Kings, is India's largest state by area."
    }
}

struct PersonalityProfile {
    let methodicalScore: Double
    let expressiveScore: Double
    let complexityScore: Double
    let warmthScore: Double
    let balanceScore: Double
    
    var archetype: String {
        if methodicalScore > 0.7 && balanceScore > 0.7 { return "The Architect" }
        if expressiveScore > 0.7 && complexityScore > 0.7 { return "The Festival Dancer" }
        if warmthScore < 0.3 && methodicalScore > 0.5 { return "The Moonlit Sage" }
        if warmthScore > 0.7 && expressiveScore > 0.5 { return "The Desert Bloom" }
        if complexityScore < 0.3 { return "The Zen Minimalist" }
        if balanceScore > 0.6 && warmthScore > 0.4 { return "The Palace Artisan" }
        return "The Free Spirit"
    }
    
    var archetypeDescription: String {
        switch archetype {
        case "The Architect": return "Methodical and symmetric — you appreciate order and mathematical precision."
        case "The Festival Dancer": return "Wild, expressive, and full of life, like Holi in Pushkar."
        case "The Moonlit Sage": return "Cool and introspective — beauty in restraint and quiet eloquence."
        case "The Desert Bloom": return "Warm and effusive — blooming like marigolds in the Thar."
        case "The Zen Minimalist": return "Less is more — honoring Japanese Ma (negative space)."
        case "The Palace Artisan": return "Balanced and warm — precision of a Meenakari artist."
        default: return "Uncategorizable — your patterns defy expectation."
        }
    }
    
    var archetypeIcon: String {
        switch archetype {
        case "The Architect": return "square.grid.3x3.fill"
        case "The Festival Dancer": return "figure.dance"
        case "The Moonlit Sage": return "moon.fill"
        case "The Desert Bloom": return "sun.max.fill"
        case "The Zen Minimalist": return "circle"
        case "The Palace Artisan": return "paintbrush.pointed.fill"
        default: return "sparkles"
        }
    }
    
    var archetypeFact: String {
        switch archetype {
        case "The Architect": return "The Jantar Mantar observatory in Jaipur, built in 1734, contains the world's largest stone sundial at 27 meters tall. Its geometric precision allows time measurement accurate to 2 seconds."
        case "The Festival Dancer": return "Ghoomar is the traditional folk dance of Rajasthan, performed by women in flowing ghaghra skirts. The word comes from 'ghoomna' (twirling), and each spin represents the cosmic dance of creation."
        case "The Moonlit Sage": return "In Japanese aesthetics, 'Wabi-sabi' embraces imperfection and transience. Similarly, Rajasthani 'Sanjhi' art creates intricate paper-cut designs that are intentionally temporary."
        case "The Desert Bloom": return "The Thar Desert blooms spectacularly after monsoon rains. The Desert National Park near Jaisalmer is home to the Great Indian Bustard, one of the world's heaviest flying birds."
        case "The Zen Minimalist": return "In Ikebana, the concept of 'Ma' (negative space) is as important as the flowers themselves. Master Sofu Teshigahara said: 'Flowers speak through their silence.'"
        case "The Palace Artisan": return "Meenakari is the art of fusing colored glass onto gold or silver. Jaipur became the Meenakari capital when Raja Man Singh brought artisans from Lahore in the 16th century."
        default: return "Rajasthani artisans have passed down their craft through generations for over 1,000 years. Each family specializes in a unique technique, making every piece a living tradition."
        }
    }
}

struct IkebanaEvaluation {
    let shinScore: Double
    let soeScore: Double
    let taiScore: Double
    
    var overallHarmony: Double {
        let deviation = abs(shinScore - 0.8) + abs(soeScore - 0.6) + abs(taiScore - 0.4)
        return max(0, 1.0 - deviation / 2.0)
    }
    
    var feedback: String {
        if overallHarmony > 0.7 { return "Excellent Ikebana — Shin guides, Soe and Tai create depth." }
        if shinScore < 0.3 { return "Your center (Shin) needs a stronger focal flower." }
        if taiScore > soeScore { return "Outer rings overpower the middle — distribute inward." }
        return "Good start! Strengthen center-middle-outer relationships."
    }
}

struct RajasthaniSpirit {
    let artForm: String
    let description: String
    let icon: String
    let fact: String
    
    static func fromPattern(symmetry: Double, colorVariety: Int, warmth: Double) -> RajasthaniSpirit {
        if symmetry > 0.8 && colorVariety <= 2 {
            return .init(artForm: "Meenakari", description: "Precise enamel work — restrained palette, perfect symmetry.", icon: "diamond.fill", fact: "Meenakari originated in Persia and was brought to Rajasthan by Raja Man Singh I. The art involves fusing powdered glass onto gold using temperatures of over 850°C. Jaipur's Meenakari work is the only tradition that applies enamel on both sides of jewelry.")
        } else if colorVariety >= 4 {
            return .init(artForm: "Phad Painting", description: "Rich tapestry of color and narrative, like Bhilwara scrolls.", icon: "paintpalette.fill", fact: "Phad paintings from Shahpura, Bhilwara are one of India's oldest forms of narrative art. These scroll paintings depict stories of folk deities Pabuji and Devnarayan. The Joshi family has been the sole lineage of Phad painters for over 700 years.")
        } else if warmth < 0.3 {
            return .init(artForm: "Blue Pottery", description: "Cool-toned and serene — Jaipur's famous blue pottery.", icon: "cup.and.saucer.fill", fact: "Jaipur's Blue Pottery is unique because it uses no clay — it's made from quartz stone powder, glass, and multani mitti. The distinctive blue color comes from cobalt oxide. It was brought to Jaipur from Persia via Delhi in the 17th century.")
        } else if symmetry > 0.6 {
            return .init(artForm: "Marble Inlay", description: "Balanced refinement of Rajasthani palace inlay work.", icon: "building.columns.fill", fact: "Parchin kari (marble inlay) in Rajasthan uses semi-precious stones like lapis lazuli, malachite, and mother-of-pearl. Artisans in Agra and Jaipur still use the same techniques used to build the Taj Mahal, cutting stones to 0.5mm precision by hand.")
        } else {
            return .init(artForm: "Bandhani", description: "Free-flowing — the spirit of tie-dye textiles.", icon: "circle.grid.3x3.fill", fact: "Bandhani (tie-and-dye) is a 5,000-year-old textile art. The earliest evidence was found in the Indus Valley Civilization. Artisans in Jodhpur and Jaipur can tie up to 800 knots per hour, with a single sari containing over 16,000 dots.")
        }
    }
}

struct MandalaInsight {
    let mood: MandalasMood
    let personality: PersonalityProfile
    let ikebana: IkebanaEvaluation
    let spirit: RajasthaniSpirit
    let harmonyScore: Int
    let dimensions: [String: Double]
}

// MARK: - Insight Engine

class InsightEngine {
    
    static func analyze(slots: [HarmonyScorer.MandalaSlotData]) -> MandalaInsight {
        let occupied = slots.filter { $0.flower != nil }
        let total = max(slots.count, 1)
        let maxRing = slots.map { $0.ring }.max() ?? 1
        
        // Completeness
        let completeness = Double(occupied.count) / Double(total)
        
        // Strict symmetry per ring
        var symPoints = 0.0
        var ringN = 0
        for ring in 0...maxRing {
            let rs = slots.filter { $0.ring == ring }
            let variants = Set(rs.compactMap { $0.flower?.id })
            if variants.count == 1 && rs.allSatisfy({ $0.flower != nil }) {
                symPoints += 1.0
            } else if !variants.isEmpty {
                symPoints += 0.2
            }
            ringN += 1
        }
        let symmetry = symPoints / Double(max(ringN, 1))
        
        // Color variety
        let uniqueColors = Set(occupied.compactMap { $0.flower?.colorName })
        let colorVariety = uniqueColors.count
        let colorHarmony = colorVariety >= 3 && colorVariety <= 4 ? 1.0 : colorVariety == 2 ? 0.65 : colorVariety == 1 ? 0.3 : 0.5
        
        // Warmth
        let warmFlowers = Set(["Marigold", "Rose", "Sunflower", "Dahlia", "Hibiscus", "Champa"])
        let warmCount = occupied.filter { warmFlowers.contains($0.flower?.type.rawValue ?? "") }.count
        let warmth = Double(warmCount) / Double(max(occupied.count, 1))
        
        // Ikebana
        let centerFilled = slots.filter { $0.ring == 0 && $0.flower != nil }.count > 0
        let midRings = slots.filter { $0.ring >= 1 && $0.ring <= maxRing / 2 }
        let midRatio = Double(midRings.filter { $0.flower != nil }.count) / Double(max(midRings.count, 1))
        let outerRings = slots.filter { $0.ring > maxRing / 2 }
        let outerRatio = Double(outerRings.filter { $0.flower != nil }.count) / Double(max(outerRings.count, 1))
        let shinScore = centerFilled ? 1.0 : 0.0
        let ikebana = IkebanaEvaluation(shinScore: shinScore, soeScore: midRatio, taiScore: outerRatio)
        
        // Tint usage
        let tintedCount = occupied.filter { $0.tint != .natural }.count
        let tintUsage = Double(tintedCount) / Double(max(occupied.count, 1))
        
        // Ring variety
        var prevFlower: String? = nil
        var ringVarPoints = 0.0
        for ring in 0...maxRing {
            let dominant = slots.filter { $0.ring == ring }.compactMap { $0.flower?.type.rawValue }.first
            if let d = dominant, d != prevFlower { ringVarPoints += 1.0 }
            prevFlower = dominant
        }
        let ringVariety = ringVarPoints / Double(max(maxRing + 1, 1))
        
        // Complexity
        let uniqueTypes = Set(occupied.compactMap { $0.flower?.type.rawValue }).count
        let complexityRaw = min(1.0, (Double(maxRing >= 3 ? 1 : 0) * 0.33 + Double(uniqueTypes >= 3 ? 1 : 0) * 0.33 + (occupied.count >= 15 ? 0.34 : Double(occupied.count) / 45.0)))
        
        // Harmony score from HarmonyScorer
        let harmonyResult = HarmonyScorer.evaluate(slots: slots)
        
        // Sentiment boost
        let sentiment = analyzeSentiment(occupied: occupied, colorVariety: colorVariety, symmetry: symmetry)
        
        // Mood
        let mood = deriveMood(symmetry: symmetry, warmth: warmth, completeness: completeness, colorVariety: colorVariety, sentiment: sentiment, tintUsage: tintUsage, complexity: complexityRaw)
        
        // Personality
        let personality = PersonalityProfile(
            methodicalScore: symmetry,
            expressiveScore: min(1.0, Double(colorVariety) / 5.0),
            complexityScore: complexityRaw,
            warmthScore: warmth,
            balanceScore: symmetry * 0.5 + ringVariety * 0.5
        )
        
        // Spirit
        let spirit = RajasthaniSpirit.fromPattern(symmetry: symmetry, colorVariety: colorVariety, warmth: warmth)
        
        // Dimensions for radar
        let dimensions: [String: Double] = [
            "Symmetry": symmetry,
            "Color": colorHarmony,
            "Completeness": completeness,
            "Ikebana": ikebana.overallHarmony,
            "Tint": tintUsage,
            "Variety": ringVariety,
            "Complexity": complexityRaw
        ]
        
        return MandalaInsight(
            mood: mood,
            personality: personality,
            ikebana: ikebana,
            spirit: spirit,
            harmonyScore: harmonyResult.score,
            dimensions: dimensions
        )
    }
    
    private static func analyzeSentiment(occupied: [HarmonyScorer.MandalaSlotData], colorVariety: Int, symmetry: Double) -> Double {
        let names = Array(Set(occupied.compactMap { $0.flower?.type.rawValue }))
        var text = "A display of \(names.joined(separator: " and ")). "
        if symmetry > 0.7 { text += "Beautifully symmetric. " }
        if colorVariety > 3 { text += "Vibrant eclectic colors! " }
        else if colorVariety == 1 { text += "Serene focus in a single hue. " }
        
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (tag, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        if let tag = tag, let score = Double(tag.rawValue) { return score }
        return 0.0
    }
    
    private static func deriveMood(symmetry: Double, warmth: Double, completeness: Double, colorVariety: Int, sentiment: Double, tintUsage: Double, complexity: Double) -> MandalasMood {
        // 12 moods with richer differentiation
        if symmetry > 0.85 && completeness > 0.8 && colorVariety <= 2 { return .serene }
        if symmetry > 0.8 && colorVariety <= 2 { return .calm }
        if colorVariety >= 4 && warmth > 0.6 { return .energetic }
        if colorVariety >= 4 && warmth <= 0.6 { return .joyful }
        if complexity > 0.7 && symmetry > 0.6 { return .intricate }
        if symmetry > 0.7 && completeness > 0.7 { return .harmonious }
        if warmth > 0.7 && completeness > 0.5 { return .radiant }
        if warmth > 0.6 { return .passionate }
        if completeness < 0.2 { return .mystic }
        if completeness < 0.4 { return .contemplative }
        if symmetry > 0.5 && warmth < 0.4 { return .grounded }
        if symmetry < 0.35 { return .chaotic }
        return sentiment > 0.2 ? .harmonious : .contemplative
    }
}
