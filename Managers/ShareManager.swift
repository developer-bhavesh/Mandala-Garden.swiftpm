import SwiftUI
import UIKit

/// Share manager — creates composite images for sharing
@MainActor
final class ShareManager {
    static let shared = ShareManager()
    private init() {}
    
    func shareMandala(snapshot: MandalaSnapshot, from viewController: UIViewController?) {
        guard let image = UIImage(contentsOfFile: snapshot.imageURL.path) else { return }
        
        // Create composite image with personality summary
        let compositeImage = createCompositeImage(mandalaImage: image, snapshot: snapshot)
        
        let items: [Any] = [
            compositeImage,
            "Created with Mandala Garden 🌸 — Harmony Score: \(snapshot.score)%"
        ]
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList]
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = viewController?.view
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        viewController?.present(activityVC, animated: true)
    }
    
    func shareFromScene(sceneView: SKView?, snapshot: MandalaSnapshot, from viewController: UIViewController?) {
        guard let skView = sceneView else { return }
        
        UIGraphicsBeginImageContextWithOptions(skView.bounds.size, false, 0)
        skView.drawHierarchy(in: skView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let mandalaImage = image else { return }
        let compositeImage = createCompositeImage(mandalaImage: mandalaImage, snapshot: snapshot)
        
        let items: [Any] = [
            compositeImage,
            "Created with Mandala Garden 🌸 — Harmony Score: \(snapshot.score)%"
        ]
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController?.present(activityVC, animated: true)
    }
    
    private func createCompositeImage(mandalaImage: UIImage, snapshot: MandalaSnapshot) -> UIImage {
        let imageSize = mandalaImage.size
        let barHeight: CGFloat = 80
        let totalSize = CGSize(width: imageSize.width, height: imageSize.height + barHeight)
        
        UIGraphicsBeginImageContextWithOptions(totalSize, true, mandalaImage.scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return mandalaImage }
        
        // Draw mandala
        mandalaImage.draw(in: CGRect(origin: .zero, size: imageSize))
        
        // Draw info bar
        let barRect = CGRect(x: 0, y: imageSize.height, width: imageSize.width, height: barHeight)
        ctx.setFillColor(UIColor(white: 0.1, alpha: 1.0).cgColor)
        ctx.fill(barRect)
        
        // Draw text
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Georgia-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]
        let subtitleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Georgia", size: 12) ?? UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.white.withAlphaComponent(0.6)
        ]
        
        let title = "🌸 Mandala Garden — \(snapshot.moodTag)"
        let subtitle = "Harmony: \(snapshot.score)% | \(snapshot.date.formatted(date: .abbreviated, time: .omitted))"
        
        let titleNS = title as NSString
        let subtitleNS = subtitle as NSString
        
        titleNS.draw(at: CGPoint(x: 16, y: imageSize.height + 14), withAttributes: titleAttrs)
        subtitleNS.draw(at: CGPoint(x: 16, y: imageSize.height + 42), withAttributes: subtitleAttrs)
        
        let result = UIGraphicsGetImageFromCurrentImageContext() ?? mandalaImage
        UIGraphicsEndImageContext()
        return result
    }
}

import SpriteKit
