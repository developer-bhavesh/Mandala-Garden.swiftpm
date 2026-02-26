import SwiftUI
import Combine

enum AppScreen: Equatable {
    case menu
    case game
    case gallery
    case settings
    case about
    case insight
}

enum PaletteTool: String, CaseIterable, Identifiable {
    case eraser = "Eraser"
    case slideFill = "Slide Fill"
    
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .eraser: return "eraser.fill"
        case .slideFill: return "hand.draw.fill"
        }
    }
}

struct MandalaSnapshot: Identifiable, Codable {
    let id: UUID
    let date: Date
    let score: Int
    let moodTag: String
    let personalityReport: PersonalityReport?
    
    var imageURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("\(id.uuidString).png")
    }
    
    init(score: Int, moodTag: String = "Unknown", report: PersonalityReport? = nil) {
        self.id = UUID()
        self.date = Date()
        self.score = score
        self.moodTag = moodTag
        self.personalityReport = report
    }
}

enum GridShape: String, CaseIterable, Identifiable {
    case dot = "Dot"
    case line = "Line"
    case triangle = "Triangle"
    case star = "Star"
    
    var id: String { rawValue }
}

// Color tint options for flowers
enum FlowerTint: String, CaseIterable, Identifiable, Codable {
    case natural = "Natural"
    case warm = "Warm"
    case cool = "Cool"
    
    var id: String { rawValue }
    
    var tintColor: Color {
        switch self {
        case .natural: return .white
        case .warm: return Color(red: 1.0, green: 0.85, blue: 0.6)
        case .cool: return Color(red: 0.7, green: 0.85, blue: 1.0)
        }
    }
    
    var blendFactor: CGFloat {
        switch self {
        case .natural: return 0.0
        case .warm: return 0.25
        case .cool: return 0.25
        }
    }
}

// Undo action record
struct UndoAction {
    enum ActionType {
        case placeFlower(slotIDs: [Int], previousVariants: [Int: FlowerVariant?])
        case removeFlower(slotIDs: [Int], previousVariants: [Int: FlowerVariant?])
        case placeGridShape(slotIDs: [Int])
    }
    let type: ActionType
}

@MainActor
class GameState: ObservableObject {
    @Published var currentScreen: AppScreen = .menu
    
    @Published var harmonyScore: Int = 0
    @Published var harmonyFeedback: String = "A blank garden awaits your creative touch."
    @Published var currentMoodIcon: String = "leaf.fill"
    @Published var currentMoodLabel: String = "Awaiting"
    @Published var currentInsight: MandalaInsight?
    @Published var currentReport: PersonalityReport?
    var lastSlotData: [HarmonyScorer.MandalaSlotData] = []
    
    // All flowers and cities unlocked
    @Published var unlockedFlowerIDs: Set<String> = Set(["lotus", "marigold", "hibiscus", "rose", "jasmine", "champa", "sunflower", "dahlia"])
    
    @Published var selectedGrid: String = "jaipur" {
        didSet { objectWillChange.send() }
    }
    
    // Active theme derived from selectedGrid
    var activeTheme: CityTheme {
        CityTheme.forKey(selectedGrid)
    }
    
    @Published var selectedFlower: FlowerVariant? = nil {
        didSet {
            if selectedFlower != nil {
                selectedGridShape = nil
                activeTool = nil
            }
        }
    }
    @Published var selectedGridShape: GridShape? = nil {
        didSet {
            if selectedGridShape != nil {
                selectedFlower = nil
                activeTool = nil
            }
        }
    }
    @Published var selectedTint: FlowerTint = .natural
    @Published var activeTool: PaletteTool? = nil {
        didSet {
            if activeTool != nil {
                // SlideFill needs a flower selected — don't clear it
                if activeTool != .slideFill {
                    selectedFlower = nil
                }
                selectedGridShape = nil
            }
        }
    }
    
    @Published var savedMandalas: [MandalaSnapshot] = []
    
    @Published var symmetryCount: Int = 8
    @Published var ringCount: Int = 4
    
    // Behavioral metrics for personality analysis
    @Published var undoCount: Int = 0
    @Published var flowerChanges: Int = 0
    @Published var sessionStartTime: Date = Date()
    @Published var slotsFilledCount: Int = 0
    @Published var slotsErasedCount: Int = 0
    
    // Combo & streak
    @Published var currentStreak: Int = 0
    @Published var lastPlacedFlower: String? = nil
    
    // Undo stack
    var undoStack: [UndoAction] = []
    let maxUndo = 20
    
    private let saveKey = "MandalaGarden.SavedMandalas"
    
    init() {
        loadProgress()
        // Random city theme on each launch
        let allCities = ["jaipur", "jodhpur", "udaipur", "jaisalmer", "bikaner", "pushkar", "chittorgarh"]
        selectedGrid = allCities.randomElement() ?? "jaipur"
    }
    
    func navigate(to screen: AppScreen) {
        withAnimation(.easeInOut(duration: 0.35)) {
            currentScreen = screen
        }
    }
    
    func pushUndo(_ action: UndoAction) {
        undoStack.append(action)
        if undoStack.count > maxUndo {
            undoStack.removeFirst()
        }
        undoCount += 1
    }
    
    func popUndo() -> UndoAction? {
        return undoStack.popLast()
    }
    
    func trackFlowerPlaced(_ flower: String) {
        slotsFilledCount += 1
        if flower != lastPlacedFlower {
            flowerChanges += 1
            currentStreak = 1
        } else {
            currentStreak += 1
        }
        lastPlacedFlower = flower
    }
    
    func trackSlotErased() {
        slotsErasedCount += 1
        currentStreak = 0
    }
    
    func resetSessionMetrics() {
        undoCount = 0
        flowerChanges = 0
        slotsFilledCount = 0
        slotsErasedCount = 0
        currentStreak = 0
        lastPlacedFlower = nil
        sessionStartTime = Date()
    }
    
    func evaluateHarmony(slots: [HarmonyScorer.MandalaSlotData]) {
        lastSlotData = slots
        let insight = InsightEngine.analyze(slots: slots)
        currentInsight = insight
        harmonyScore = insight.harmonyScore
        currentMoodIcon = insight.mood.icon
        currentMoodLabel = insight.mood.rawValue
        
        // Generate personality report
        let sessionDuration = Date().timeIntervalSince(sessionStartTime)
        let report = PersonalityEngine.analyze(
            slots: slots,
            undoCount: undoCount,
            flowerChanges: flowerChanges,
            sessionDuration: sessionDuration,
            slotsFilledCount: slotsFilledCount,
            slotsErasedCount: slotsErasedCount
        )
        currentReport = report
        
        let occupied = slots.filter { $0.flower != nil }
        if occupied.isEmpty {
            harmonyFeedback = "A blank garden awaits your creative touch."
            currentMoodIcon = "leaf.fill"
            currentMoodLabel = "Awaiting"
        } else {
            harmonyFeedback = "\(insight.mood.rawValue) — \(insight.personality.archetype)"
        }
    }
    
    func saveSnapshot(imageData: Data) {
        let snapshot = MandalaSnapshot(score: harmonyScore, moodTag: currentMoodLabel, report: currentReport)
        do {
            try imageData.write(to: snapshot.imageURL)
            savedMandalas.insert(snapshot, at: 0)
            saveProgress()
        } catch {
            print("Failed to save snapshot: \(error)")
        }
    }
    
    private func saveProgress() {
        if let encoded = try? JSONEncoder().encode(savedMandalas) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([MandalaSnapshot].self, from: data) {
            savedMandalas = decoded
        }
    }
}
