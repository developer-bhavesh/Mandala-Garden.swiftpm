import Foundation
import NaturalLanguage

struct HarmonyResult {
    let score: Int
    let feedback: String
}

class HarmonyScorer {
    
    struct MandalaSlotData {
        let id: Int
        let ring: Int
        let angleIndex: Int
        let flower: FlowerVariant?
        let tint: FlowerTint
        
        init(id: Int, ring: Int, angleIndex: Int, flower: FlowerVariant?, tint: FlowerTint = .natural) {
            self.id = id
            self.ring = ring
            self.angleIndex = angleIndex
            self.flower = flower
            self.tint = tint
        }
    }
    
    static func evaluate(slots: [MandalaSlotData]) -> HarmonyResult {
        let occupied = slots.filter { $0.flower != nil }
        if occupied.isEmpty {
            return HarmonyResult(score: 0, feedback: "A blank garden awaits.")
        }
        
        let total = slots.count
        let maxRing = slots.map { $0.ring }.max() ?? 1
        
        // 1. Completeness (15 pts) — needs 100% for full
        let completeness = Double(occupied.count) / Double(max(total, 1)) * 15.0
        
        // 2. Strict Symmetry (15 pts) — EVERY ring must have identical flowers
        var symmetryPoints = 0.0
        var ringCount = 0
        for ring in 0...maxRing {
            let ringSlots = slots.filter { $0.ring == ring }
            let variants = Set(ringSlots.compactMap { $0.flower?.id })
            if variants.count == 1 && ringSlots.allSatisfy({ $0.flower != nil }) {
                symmetryPoints += 1.0 // Full mark only if ALL slots in ring identical
            } else if variants.isEmpty {
                symmetryPoints += 0.0 // Empty ring = no score
            } else {
                symmetryPoints += 0.2 // Partial fill = tiny credit
            }
            ringCount += 1
        }
        let symmetryScore = (symmetryPoints / Double(max(ringCount, 1))) * 15.0
        
        // 3. Color Harmony (15 pts) — ideal = 3-4 unique colors with warm/cool mix
        let colors = occupied.compactMap { $0.flower?.colorName }
        let uniqueColors = Set(colors)
        var colorScore = 0.0
        if uniqueColors.count >= 3 && uniqueColors.count <= 4 {
            colorScore = 15.0
        } else if uniqueColors.count == 2 {
            colorScore = 10.0
        } else if uniqueColors.count == 1 {
            colorScore = 5.0
        } else if uniqueColors.count >= 5 {
            colorScore = 8.0 // Too many = less harmony
        }
        
        // 4. Ring Variety (10 pts) — each ring should use DIFFERENT flower than adjacent
        var ringVariety = 0.0
        var prevFlower: String? = nil
        for ring in 0...maxRing {
            let dominant = slots.filter { $0.ring == ring }
                .compactMap { $0.flower?.type.rawValue }
                .first
            if let d = dominant, d != prevFlower {
                ringVariety += 1.0
            }
            prevFlower = dominant
        }
        let ringVarietyScore = (ringVariety / Double(max(maxRing + 1, 1))) * 10.0
        
        // 5. Ikebana Flow (15 pts)
        let centerFilled = slots.filter { $0.ring == 0 && $0.flower != nil }.count > 0
        let midRings = slots.filter { $0.ring >= 1 && $0.ring <= maxRing / 2 }
        let midRatio = Double(midRings.filter { $0.flower != nil }.count) / Double(max(midRings.count, 1))
        let outerRings = slots.filter { $0.ring > maxRing / 2 }
        let outerRatio = Double(outerRings.filter { $0.flower != nil }.count) / Double(max(outerRings.count, 1))
        var ikebanaScore = 0.0
        if centerFilled { ikebanaScore += 5.0 }
        ikebanaScore += midRatio * 5.0
        ikebanaScore += outerRatio * 5.0
        
        // 6. Complexity (15 pts) — requires min rings, folds, flower types
        let uniqueFlowerTypes = Set(occupied.compactMap { $0.flower?.type.rawValue }).count
        var complexityScore = 0.0
        if maxRing >= 3 { complexityScore += 5.0 }
        if uniqueFlowerTypes >= 3 { complexityScore += 5.0 }
        if occupied.count >= 20 { complexityScore += 5.0 }
        else if occupied.count >= 10 { complexityScore += 2.5 }
        
        // 7. Tint Usage (15 pts) — must use non-natural tints
        let tintedCount = occupied.filter { $0.tint != .natural }.count
        let tintRatio = Double(tintedCount) / Double(max(occupied.count, 1))
        let tintScore = tintRatio * 15.0
        
        let rawTotal = completeness + symmetryScore + colorScore + ringVarietyScore + ikebanaScore + complexityScore + tintScore
        let finalScore = max(0, min(100, Int(rawTotal)))
        
        return HarmonyResult(score: finalScore, feedback: generateFeedback(score: finalScore))
    }
    
    private static func generateFeedback(score: Int) -> String {
        switch score {
        case 0..<15:
            return "A humble start. Like morning dew on desert sand."
        case 15..<30:
            return "The seeds of beauty are planted. Try filling entire rings uniformly."
        case 30..<50:
            return "Your garden grows! Vary flowers per ring and try color tints."
        case 50..<70:
            return "Beautiful composition. The radial flow echoes Jali stonework."
        case 70..<85:
            return "A royal arrangement! Focus on tints and ring variety for mastery."
        case 85...100:
            return "Supreme Harmony! A masterpiece worthy of a Maharaja's palace."
        default:
            return "Your creativity knows no bounds."
        }
    }
}
