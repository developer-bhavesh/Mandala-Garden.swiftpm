import SpriteKit

class SlotNode: SKSpriteNode {
    let id: Int
    let ring: Int
    let angleIndex: Int

    var isOccupied: Bool { flowerNode != nil }
    var flowerNode: FlowerNode?

    private var slotCircle: SKShapeNode!
    private var glowCircle: SKShapeNode!

    init(id: Int, ring: Int, angleIndex: Int) {
        self.id = id
        self.ring = ring
        self.angleIndex = angleIndex

        let baseSize: CGFloat = ring == 0 ? 46 : 38 + CGFloat(min(ring, 6)) * 1.5
        super.init(texture: nil, color: .clear, size: CGSize(width: baseSize, height: baseSize))
        self.name = "slot_\(id)"
        self.zPosition = 5

        let radius = baseSize / 2.4

        let glow = SKShapeNode(circleOfRadius: radius + 3)
        glow.fillColor = .clear
        glow.strokeColor = UIColor.white.withAlphaComponent(0.2)
        glow.lineWidth = 1
        glow.zPosition = -1
        glow.alpha = 0.5
        self.addChild(glow)
        self.glowCircle = glow

        let circle = SKShapeNode(circleOfRadius: radius)
        circle.fillColor = UIColor.black.withAlphaComponent(0.15)
        circle.strokeColor = UIColor.white.withAlphaComponent(0.3)
        circle.lineWidth = 1.5
        circle.zPosition = 0
        self.addChild(circle)
        self.slotCircle = circle

        let fadeOut = SKAction.fadeAlpha(to: 0.2, duration: 1.8)
        let fadeIn = SKAction.fadeAlpha(to: 0.5, duration: 1.8)
        glow.run(SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn])))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func placeFlower(_ variant: FlowerVariant, tint: FlowerTint = .natural) {
        flowerNode?.removeFromParent()
        let newFlower = FlowerNode(variant: variant, tint: tint)
        self.addChild(newFlower)
        self.flowerNode = newFlower
        slotCircle.isHidden = true
        glowCircle.isHidden = true
        newFlower.dropAnimation()
    }

    func clear() {
        flowerNode?.removeFromParent()
        flowerNode = nil
        slotCircle.isHidden = false
        glowCircle.isHidden = false
    }
}
