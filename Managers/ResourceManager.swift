import SwiftUI
import SpriteKit
import UIKit

enum FlowerType: String, CaseIterable {
    case lotus = "Lotus"
    case marigold = "Marigold"
    case hibiscus = "Hibiscus"
    case jasmine = "Jasmine"
    case rose = "Rose"
    case champa = "Champa"
    case sunflower = "Sunflower"
    case dahlia = "Dahlia"

    var imageName: String { rawValue.lowercased() }

    var uiColor: Color {
        switch self {
        case .lotus: return AppColors.jaipurPink
        case .marigold: return AppColors.royalGold
        case .hibiscus: return AppColors.deepMaroon
        case .jasmine: return AppColors.mograWhite
        case .rose: return Color(red: 0.8, green: 0.3, blue: 0.4)
        case .champa: return Color(red: 0.95, green: 0.85, blue: 0.5)
        case .sunflower: return Color(red: 0.95, green: 0.8, blue: 0.2)
        case .dahlia: return Color(red: 0.6, green: 0.2, blue: 0.5)
        }
    }
}

struct FlowerVariant: Identifiable, Hashable {
    let id: String
    let type: FlowerType
    let color: Color
    let colorName: String
    let isLockedByDefault: Bool

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: FlowerVariant, rhs: FlowerVariant) -> Bool { lhs.id == rhs.id }
}

@MainActor
class ResourceManager {
    static let shared = ResourceManager()

    private(set) var allFlowers: [FlowerVariant] = []
    private(set) var allGrids: [String] = []

    private var circularTextureCache: [String: SKTexture] = [:]
    private var circularUIImageCache: [String: UIImage] = [:]

    private init() {
        buildFlowerCatalog()
    }

    private func buildFlowerCatalog() {
        allFlowers = FlowerType.allCases.map { type in
            FlowerVariant(
                id: type.imageName,
                type: type,
                color: type.uiColor,
                colorName: type.rawValue,
                isLockedByDefault: !(type == .lotus || type == .marigold)
            )
        }
        allGrids = ["jaipur", "jodhpur", "udaipur", "jaisalmer", "bikaner", "pushkar", "chittorgarh"]
    }

    // MARK: - Circular Texture (for SpriteKit — no square background)

    func flowerTexture(for type: FlowerType) -> SKTexture {
        let key = type.imageName
        if let cached = circularTextureCache[key] { return cached }

        if let circular = circularImage(for: type, size: 80) {
            let tex = SKTexture(image: circular)
            tex.filteringMode = .linear
            circularTextureCache[key] = tex
            return tex
        }
        return fallbackTexture()
    }

    // MARK: - Circular UIImage (for SwiftUI palette)

    func flowerUIImage(for type: FlowerType) -> UIImage? {
        let key = type.imageName
        if let cached = circularUIImageCache[key] { return cached }

        if let circular = circularImage(for: type, size: 120) {
            circularUIImageCache[key] = circular
            return circular
        }
        return nil
    }

    func texture(named name: String) -> SKTexture {
        if let type = FlowerType.allCases.first(where: { $0.imageName == name }) {
            return flowerTexture(for: type)
        }
        return fallbackTexture()
    }

    func uiImage(named name: String) -> UIImage? {
        return loadBundleImage(named: name)
    }

    // MARK: - Circular Crop

    /// Loads the raw PNG, draws it on a solid background circle, clipped to circle
    private func circularImage(for type: FlowerType, size: CGFloat) -> UIImage? {
        guard let rawImage = loadBundleImage(named: type.imageName) else { return nil }

        let outputSize = CGSize(width: size, height: size)
        UIGraphicsBeginImageContextWithOptions(outputSize, false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }

        let circleRect = CGRect(origin: .zero, size: outputSize)

        // Clip everything to a circle
        ctx.addEllipse(in: circleRect)
        ctx.clip()

        // 1. Draw solid sandstone background (matches mandala canvas) to cover checkerboard
        let bgColor = UIColor(red: 0.96, green: 0.93, blue: 0.86, alpha: 1) // AppColors.sandstone
        ctx.setFillColor(bgColor.cgColor)
        ctx.fill(circleRect)

        // 2. Draw the flower image scaled to fill the circle
        // Inset slightly so the flower doesn't paint over the circle edge
        let insetRect = circleRect.insetBy(dx: size * 0.02, dy: size * 0.02)
        rawImage.draw(in: insetRect)

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    // MARK: - Private Helpers

    private func loadBundleImage(named name: String) -> UIImage? {
        if let url = Bundle.main.url(forResource: name, withExtension: "png"),
           let img = UIImage(contentsOfFile: url.path) {
            return img
        }
        if let img = UIImage(named: name) { return img }
        return nil
    }

    private func fallbackTexture() -> SKTexture {
        let size = CGSize(width: 64, height: 64)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(UIColor(AppColors.jaipurPink).cgColor)
        ctx.fillEllipse(in: CGRect(origin: .zero, size: size).insetBy(dx: 4, dy: 4))
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return SKTexture(image: img)
    }
}
