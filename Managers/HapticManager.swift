import UIKit

/// Centralized haptic feedback manager (Single Responsibility)
@MainActor
final class HapticManager {
    static let shared = HapticManager()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let notification = UINotificationFeedbackGenerator()
    private let selection = UISelectionFeedbackGenerator()
    
    var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "HapticsEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "HapticsEnabled") }
    }
    
    private init() {
        // Default to enabled
        if UserDefaults.standard.object(forKey: "HapticsEnabled") == nil {
            UserDefaults.standard.set(true, forKey: "HapticsEnabled")
        }
    }
    
    func prepare() {
        lightImpact.prepare()
        mediumImpact.prepare()
    }
    
    func placement() {
        guard isEnabled else { return }
        lightImpact.impactOccurred()
    }
    
    func erase() {
        guard isEnabled else { return }
        mediumImpact.impactOccurred(intensity: 0.6)
    }
    
    func streak() {
        guard isEnabled else { return }
        notification.notificationOccurred(.success)
    }
    
    func toolSwitch() {
        guard isEnabled else { return }
        selection.selectionChanged()
    }
    
    func achievement() {
        guard isEnabled else { return }
        notification.notificationOccurred(.success)
    }
    
    func error() {
        guard isEnabled else { return }
        notification.notificationOccurred(.error)
    }
    
    func reset() {
        guard isEnabled else { return }
        heavyImpact.impactOccurred(intensity: 0.8)
    }
}
