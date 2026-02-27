import Foundation

/// Auto-save draft manager for in-progress mandalas (Single Responsibility)
@MainActor
final class DraftManager {
    static let shared = DraftManager()
    
    private let draftKey = "MandalaGarden.Draft"
    private let themeKey = "MandalaGarden.DraftTheme"
    
    private init() {}
    
    struct DraftSlot: Codable {
        let id: Int
        let ring: Int
        let angleIndex: Int
        let flowerType: String?
        let tint: String
    }
    
    func saveDraft(slots: [(id: Int, ring: Int, angleIndex: Int, flowerType: String?, tint: String)], themeKey: String) {
        let drafts = slots.map { DraftSlot(id: $0.id, ring: $0.ring, angleIndex: $0.angleIndex, flowerType: $0.flowerType, tint: $0.tint) }
        if let data = try? JSONEncoder().encode(drafts) {
            UserDefaults.standard.set(data, forKey: draftKey)
            UserDefaults.standard.set(themeKey, forKey: self.themeKey)
        }
    }
    
    func loadDraft() -> (slots: [DraftSlot], theme: String)? {
        guard let data = UserDefaults.standard.data(forKey: draftKey),
              let drafts = try? JSONDecoder().decode([DraftSlot].self, from: data),
              !drafts.isEmpty else { return nil }
        let theme = UserDefaults.standard.string(forKey: themeKey) ?? "jaipur"
        return (drafts, theme)
    }
    
    func hasDraft() -> Bool {
        return UserDefaults.standard.data(forKey: draftKey) != nil
    }
    
    func clearDraft() {
        UserDefaults.standard.removeObject(forKey: draftKey)
        UserDefaults.standard.removeObject(forKey: themeKey)
    }
}
