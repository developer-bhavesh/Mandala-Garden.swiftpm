import AVFoundation
import AudioToolbox

/// Sound manager using system sounds (no bundled audio files needed)
@MainActor
final class SoundManager {
    static let shared = SoundManager()
    
    var isSoundEnabled: Bool {
        get { UserDefaults.standard.object(forKey: "SoundEnabled") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "SoundEnabled") }
    }
    
    private init() {
        if UserDefaults.standard.object(forKey: "SoundEnabled") == nil {
            UserDefaults.standard.set(true, forKey: "SoundEnabled")
        }
    }
    
    func playPlacement() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1104) // Soft pop
    }
    
    func playErase() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1155) // Soft delete
    }
    
    func playStreak() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1025) // Success chime
    }
    
    func playAchievement() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1026) // Achievement chime
    }
    
    func playReset() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1156) // Sweep
    }
    
    func playSave() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1001) // Camera shutter
    }
    
    func playToolSwitch() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1103) // Tick
    }
}
