import Foundation

/// Daily challenge system — deterministic daily selection based on date hash
struct DailyChallenge {
    let title: String
    let description: String
    let icon: String
    let check: ([HarmonyScorer.MandalaSlotData]) -> Bool
}

@MainActor
final class DailyChallengeManager {
    static let shared = DailyChallengeManager()
    
    private let completedKey = "MandalaGarden.DailyChallengeCompleted"
    private let completedDateKey = "MandalaGarden.DailyChallengeDate"
    
    private init() {}
    
    private let challenges: [(title: String, desc: String, icon: String, check: ([HarmonyScorer.MandalaSlotData]) -> Bool)] = [
        ("Warm Garden", "Use only warm flowers (Marigold, Sunflower, Hibiscus)", "flame.fill", { slots in
            let occupied = slots.filter { $0.flower != nil }
            guard occupied.count >= 5 else { return false }
            let warmTypes: Set<String> = ["Marigold", "Sunflower", "Hibiscus"]
            return occupied.allSatisfy { warmTypes.contains($0.flower?.type.rawValue ?? "") }
        }),
        ("Cool Serenity", "Use only cool flowers (Lotus, Jasmine, Champa)", "snowflake", { slots in
            let occupied = slots.filter { $0.flower != nil }
            guard occupied.count >= 5 else { return false }
            let coolTypes: Set<String> = ["Lotus", "Jasmine", "Champa"]
            return occupied.allSatisfy { coolTypes.contains($0.flower?.type.rawValue ?? "") }
        }),
        ("Rainbow Garden", "Use 4 or more different flower types", "rainbow", { slots in
            let types = Set(slots.compactMap { $0.flower?.type.rawValue })
            return types.count >= 4
        }),
        ("Perfect Ring", "Fill an entire ring completely", "circle.fill", { slots in
            let maxRing = slots.map { $0.ring }.max() ?? 0
            for ring in 0...maxRing {
                let ringSlots = slots.filter { $0.ring == ring }
                if ringSlots.count >= 4 && ringSlots.allSatisfy({ $0.flower != nil }) {
                    return true
                }
            }
            return false
        }),
        ("Symmetry Master", "Fill all slots in at least 2 rings with the same flower", "star.fill", { slots in
            let maxRing = slots.map { $0.ring }.max() ?? 0
            var uniformRings = 0
            for ring in 0...maxRing {
                let ringSlots = slots.filter { $0.ring == ring }
                let types = Set(ringSlots.compactMap { $0.flower?.type.rawValue })
                if types.count == 1 && ringSlots.allSatisfy({ $0.flower != nil }) && ringSlots.count >= 4 {
                    uniformRings += 1
                }
            }
            return uniformRings >= 2
        }),
        ("Minimalist", "Create a mandala using only 2 flower types", "leaf.fill", { slots in
            let types = Set(slots.compactMap { $0.flower?.type.rawValue })
            let occupied = slots.filter { $0.flower != nil }
            return types.count == 2 && occupied.count >= 8
        }),
        ("Grand Canvas", "Place at least 20 flowers", "square.grid.3x3.fill", { slots in
            return slots.filter { $0.flower != nil }.count >= 20
        }),
        ("Tinted Vision", "Use tinted (Warm or Cool) flowers on at least 5 slots", "paintpalette.fill", { slots in
            let tinted = slots.filter { $0.flower != nil && $0.tint != .natural }
            return tinted.count >= 5
        }),
        ("Rose Garden", "Place roses on every slot in a ring", "heart.fill", { slots in
            let maxRing = slots.map { $0.ring }.max() ?? 0
            for ring in 0...maxRing {
                let ringSlots = slots.filter { $0.ring == ring }
                if ringSlots.count >= 4 && ringSlots.allSatisfy({ $0.flower?.type.rawValue == "Rose" }) {
                    return true
                }
            }
            return false
        }),
        ("Speed Creator", "Fill 10 slots in under 2 minutes", "bolt.fill", { slots in
            // This is checked with time, so just check slot count
            return slots.filter { $0.flower != nil }.count >= 10
        }),
        ("Full Bloom", "Achieve 80% or higher harmony score", "sparkles", { slots in
            // Checked externally against score
            return slots.filter { $0.flower != nil }.count >= 10
        }),
        ("Lotus Pond", "Use Lotus flowers exclusively", "drop.fill", { slots in
            let occupied = slots.filter { $0.flower != nil }
            guard occupied.count >= 6 else { return false }
            return occupied.allSatisfy { $0.flower?.type.rawValue == "Lotus" }
        }),
        ("Sunrise Palette", "Combine Marigold and Sunflower only", "sun.max.fill", { slots in
            let occupied = slots.filter { $0.flower != nil }
            guard occupied.count >= 6 else { return false }
            let allowed: Set<String> = ["Marigold", "Sunflower"]
            return occupied.allSatisfy { allowed.contains($0.flower?.type.rawValue ?? "") }
        }),
        ("Explorer", "Use every flower type at least once", "map.fill", { slots in
            let types = Set(slots.compactMap { $0.flower?.type.rawValue })
            return types.count >= 8
        }),
        ("Inner Peace", "Create a mandala with only Jasmine and Champa", "wind", { slots in
            let occupied = slots.filter { $0.flower != nil }
            guard occupied.count >= 6 else { return false }
            let allowed: Set<String> = ["Jasmine", "Champa"]
            return occupied.allSatisfy { allowed.contains($0.flower?.type.rawValue ?? "") }
        })
    ]
    
    func todayChallenge() -> DailyChallenge {
        let dayHash = Calendar.current.ordinality(of: .day, in: .era, for: Date()) ?? 0
        let index = dayHash % challenges.count
        let c = challenges[index]
        return DailyChallenge(title: c.title, description: c.desc, icon: c.icon, check: c.check)
    }
    
    func isCompletedToday() -> Bool {
        guard let savedDate = UserDefaults.standard.string(forKey: completedDateKey) else { return false }
        let today = dateString(Date())
        return savedDate == today && UserDefaults.standard.bool(forKey: completedKey)
    }
    
    func markCompleted() {
        UserDefaults.standard.set(true, forKey: completedKey)
        UserDefaults.standard.set(dateString(Date()), forKey: completedDateKey)
    }
    
    func checkChallenge(slots: [HarmonyScorer.MandalaSlotData], score: Int) -> Bool {
        let challenge = todayChallenge()
        var result = challenge.check(slots)
        // Special case for score-based challenges
        if challenge.title == "Full Bloom" {
            result = score >= 80
        }
        return result
    }
    
    private func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
}
