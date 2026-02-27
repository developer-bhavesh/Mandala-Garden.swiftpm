import SpriteKit

class FlowerNode: SKSpriteNode {
    let variant: FlowerVariant
    let appliedTint: FlowerTint

    init(variant: FlowerVariant, tint: FlowerTint = .natural) {
        self.variant = variant
        self.appliedTint = tint

        let texture = ResourceManager.shared.flowerTexture(for: variant.type)
        let displaySize = CGSize(width: 38, height: 38)

        super.init(texture: texture, color: .clear, size: displaySize)
        self.name = "flower_\(variant.id)"
        self.zPosition = 10

        // Apply tint
        if tint != .natural {
            self.color = UIColor(tint.tintColor)
            self.colorBlendFactor = tint.blendFactor
        }

        // Shadow
        let shadow = SKShapeNode(circleOfRadius: 14)
        shadow.fillColor = UIColor.black.withAlphaComponent(0.1)
        shadow.strokeColor = .clear
        shadow.zPosition = -1
        shadow.position = CGPoint(x: 1, y: -2)
        self.addChild(shadow)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func dropAnimation() {
        self.setScale(0.01)
        self.alpha = 0.5
        let scaleUp = SKAction.scale(to: 1.12, duration: 0.18)
        scaleUp.timingMode = .easeOut
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.08)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.12)
        self.run(SKAction.group([SKAction.sequence([scaleUp, scaleDown]), fadeIn]))

        let r1 = SKAction.rotate(byAngle: 0.03, duration: 2.5)
        let r2 = SKAction.rotate(byAngle: -0.03, duration: 2.5)
        self.run(SKAction.repeatForever(SKAction.sequence([r1, r2])))
    }
}
