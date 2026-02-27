import SpriteKit

class MandalaScene: SKScene {
    
    var onMandalaUpdate: (([HarmonyScorer.MandalaSlotData]) -> Void)?
    var gameState: GameState?
    
    private var slots: [SlotNode] = []
    private var worldNode = SKNode()
    private var symmetrySlices = 8
    
    private var lastScale: CGFloat = 1.0
    private var slotIdCounter = 1000
    
    // Stored references for dynamic updates
    private var bgNode: SKShapeNode?
    private var ringNodes: [SKShapeNode] = []
    private var spokeNodes: [SKShapeNode] = []
    private var jaliNodes: [SKShapeNode] = []
    private var currentBgRadius: CGFloat = 320.0
    
    // Touch state for drag vs tap detection
    private var touchStart: CGPoint?
    private var touchStartWorld: CGPoint?
    private var isDragging = false
    private let dragThreshold: CGFloat = 8.0
    private var slideFillVisited: Set<Int> = []
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(AppColors.heritageBlue)
        self.addChild(worldNode)
        
        symmetrySlices = gameState?.symmetryCount ?? 8
        setupBoard()
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.minimumNumberOfTouches = 2
        view.addGestureRecognizer(pan)
        
        // Listen for undo
        NotificationCenter.default.addObserver(self, selector: #selector(handleUndo), name: .undoAction, object: nil)
    }
    
    @objc private func handleUndo() {
        guard let action = gameState?.popUndo() else { return }
        switch action.type {
        case .placeFlower(let ids, let prev):
            for id in ids {
                if let slot = slots.first(where: { $0.id == id }) {
                    slot.clear()
                    if let oldVariant = prev[id] ?? nil {
                        slot.placeFlower(oldVariant)
                    }
                }
            }
        case .removeFlower(let ids, let prev):
            for id in ids {
                if let slot = slots.first(where: { $0.id == id }),
                   let variant = prev[id] ?? nil {
                    slot.placeFlower(variant)
                }
            }
        case .placeGridShape(let ids):
            for id in ids {
                if let idx = slots.firstIndex(where: { $0.id == id }) {
                    let slot = slots[idx]
                    slot.removeFromParent()
                    slots.remove(at: idx)
                }
            }
        }
        notifyDelegate()
    }
    
    @objc private func handlePinch(_ r: UIPinchGestureRecognizer) {
        if r.state == .began { lastScale = worldNode.xScale }
        worldNode.setScale(max(0.3, min(3.0, r.scale * lastScale)))
    }
    
    @objc private func handlePan(_ r: UIPanGestureRecognizer) {
        guard let view = self.view, r.state == .changed else { return }
        let t = r.translation(in: view)
        worldNode.position = CGPoint(x: worldNode.position.x + t.x, y: worldNode.position.y - t.y)
        r.setTranslation(.zero, in: view)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        worldNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    func setupBoard() {
        worldNode.removeAllChildren()
        slots.removeAll()
        slotIdCounter = 1000
        
        let center = CGPoint.zero
        let theme = CityTheme.forKey(gameState?.selectedGrid ?? "jaipur")
        
        let ringCount = gameState?.ringCount ?? 4
        let ringSpacing: CGFloat = 60.0
        let maxRadius = CGFloat(ringCount) * ringSpacing
        let bgRadius = max(320.0, maxRadius + 40)
        
        // Background
        let bg = SKShapeNode(circleOfRadius: bgRadius)
        bg.fillColor = UIColor(theme.bgColor)
        bg.strokeColor = UIColor(theme.ringColor).withAlphaComponent(0.25)
        bg.lineWidth = 2
        bg.zPosition = 0
        bg.name = "background"
        worldNode.addChild(bg)
        bgNode = bg
        currentBgRadius = bgRadius
        
        // Rings
        var ringRadii: [CGFloat] = []
        if ringCount > 0 {
            for i in 1...ringCount {
                ringRadii.append(CGFloat(i) * ringSpacing)
            }
        }
        
        ringNodes.removeAll()
        for radius in ringRadii {
            let ring = SKShapeNode(circleOfRadius: radius)
            ring.fillColor = .clear
            ring.strokeColor = UIColor(theme.ringColor).withAlphaComponent(0.15)
            ring.lineWidth = 1
            ring.zPosition = 1
            worldNode.addChild(ring)
            ringNodes.append(ring)
        }
        
        // Radial spokes
        let spokeLen = ringRadii.last ?? bgRadius
        spokeNodes.removeAll()
        for i in 0..<symmetrySlices {
            let angle = (2 * .pi / CGFloat(symmetrySlices)) * CGFloat(i)
            let path = CGMutablePath()
            path.move(to: center)
            path.addLine(to: CGPoint(x: spokeLen * cos(angle), y: spokeLen * sin(angle)))
            let spoke = SKShapeNode(path: path)
            spoke.strokeColor = UIColor(theme.ringColor).withAlphaComponent(0.06)
            spoke.lineWidth = 0.5
            spoke.zPosition = 1
            worldNode.addChild(spoke)
            spokeNodes.append(spoke)
        }
        
        // Jali diamonds on outer edge
        let jaliR = bgRadius - 10
        jaliNodes.removeAll()
        for i in 0..<(symmetrySlices * 2) {
            let angle = (2 * .pi / CGFloat(symmetrySlices * 2)) * CGFloat(i)
            let d = SKShapeNode(rectOf: CGSize(width: 5, height: 5))
            d.zRotation = .pi / 4
            d.fillColor = UIColor(theme.ringColor).withAlphaComponent(0.1)
            d.strokeColor = .clear
            d.position = CGPoint(x: jaliR * cos(angle), y: jaliR * sin(angle))
            d.zPosition = 1
            worldNode.addChild(d)
            jaliNodes.append(d)
        }
        
        // Center Slot
        let centerSlot = SlotNode(id: 0, ring: 0, angleIndex: 0)
        centerSlot.position = center
        worldNode.addChild(centerSlot)
        slots.append(centerSlot)
        
        var idCounter = 1
        for (ri, radius) in ringRadii.enumerated() {
            let actualRing = ri + 1
            let angleStep = (2 * .pi) / CGFloat(symmetrySlices)
            for i in 0..<symmetrySlices {
                let angle = angleStep * CGFloat(i)
                let slot = SlotNode(id: idCounter, ring: actualRing, angleIndex: i)
                slot.position = CGPoint(x: radius * cos(angle), y: radius * sin(angle))
                worldNode.addChild(slot)
                slots.append(slot)
                idCounter += 1
            }
        }
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let view = self.view else { return }
        touchStart = touch.location(in: view)
        touchStartWorld = worldNode.position
        isDragging = false
        slideFillVisited.removeAll()
        
        // If slide-fill is active with a flower selected, start filling immediately
        if gameState?.activeTool == .slideFill, let flower = gameState?.selectedFlower {
            let location = touch.location(in: worldNode)
            if let slot = findClosestSlot(at: location) {
                placeSingle(variant: flower, on: slot)
                slideFillVisited.insert(slot.id)
                notifyDelegate()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let view = self.view,
              let start = touchStart, let startWorld = touchStartWorld else { return }
        
        let current = touch.location(in: view)
        let dist = hypot(current.x - start.x, current.y - start.y)
        
        // Slide-fill tool: fill as you drag
        if gameState?.activeTool == .slideFill, let flower = gameState?.selectedFlower {
            let location = touch.location(in: worldNode)
            if let slot = findClosestSlot(at: location), !slideFillVisited.contains(slot.id) {
                placeSingle(variant: flower, on: slot)
                slideFillVisited.insert(slot.id)
                notifyDelegate()
            }
            return
        }
        
        // Check if this is a drag (canvas pan)
        if dist > dragThreshold {
            isDragging = true
            // Pan the canvas
            let dx = current.x - start.x
            let dy = current.y - start.y
            worldNode.position = CGPoint(x: startWorld.x + dx, y: startWorld.y - dy)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // If we were slide-filling, just clean up
        if gameState?.activeTool == .slideFill {
            touchStart = nil
            isDragging = false
            return
        }
        
        // If it was a drag, don't place anything
        if isDragging {
            touchStart = nil
            isDragging = false
            return
        }
        
        // It was a tap — handle placement
        let location = touch.location(in: worldNode)
        handleTap(at: location)
        touchStart = nil
        isDragging = false
    }
    
    private func findClosestSlot(at location: CGPoint, maxDistance: CGFloat = 28) -> SlotNode? {
        var closest: SlotNode? = nil
        var bestDist: CGFloat = maxDistance
        for slot in slots {
            let worldPos = slot.convert(CGPoint.zero, to: worldNode)
            let dist = location.distance(to: worldPos)
            if dist < bestDist {
                bestDist = dist
                closest = slot
            }
        }
        return closest
    }
    
    private func handleTap(at location: CGPoint) {
        // Find closest slot with distance check
        if let slot = findClosestSlot(at: location) {
            
            // Eraser tool
            if gameState?.activeTool == .eraser {
                if slot.isOccupied || slot.id >= 1000 {
                    eraseSlot(slot)
                    gameState?.trackSlotErased()
                }
                return
            }
            
            // Place flower on THIS slot only
            if let flower = gameState?.selectedFlower {
                placeSingle(variant: flower, on: slot)
                gameState?.trackFlowerPlaced(flower.type.rawValue)
                notifyDelegate()
                return
            }
            
            // No tool, no flower, no shape = remove on tap
            if gameState?.selectedFlower == nil && gameState?.selectedGridShape == nil && gameState?.activeTool == nil {
                if slot.isOccupied {
                    removeSingle(from: slot)
                    gameState?.trackSlotErased()
                    notifyDelegate()
                }
            }
            
        } else {
            // Tapped empty space — place grid shape
            if let shape = gameState?.selectedGridShape {
                placeGridShapeSymmetric(shape: shape, at: location)
                notifyDelegate()
            }
        }
    }
    
    // MARK: - Place / Remove
    
    private func placeSingle(variant: FlowerVariant, on slot: SlotNode) {
        let prevVariant = slot.flowerNode?.variant
        slot.placeFlower(variant, tint: gameState?.selectedTint ?? .natural)
        playSparkle(at: slot.position)
        gameState?.pushUndo(UndoAction(type: .placeFlower(slotIDs: [slot.id], previousVariants: [slot.id: prevVariant])))
    }
    
    private func removeSingle(from slot: SlotNode) {
        let prevVariant = slot.flowerNode?.variant
        slot.clear()
        gameState?.pushUndo(UndoAction(type: .removeFlower(slotIDs: [slot.id], previousVariants: [slot.id: prevVariant])))
    }
    
    private func eraseSlot(_ slot: SlotNode) {
        let prevVariants: [Int: FlowerVariant?] = [slot.id: slot.flowerNode?.variant]
        
        if slot.id >= 1000 {
            // Dynamic grid shape slot — remove entirely
            if let idx = slots.firstIndex(where: { $0.id == slot.id }) {
                slots.remove(at: idx)
                slot.removeFromParent()
            }
            gameState?.pushUndo(UndoAction(type: .placeGridShape(slotIDs: [slot.id])))
        } else {
            slot.clear()
            gameState?.pushUndo(UndoAction(type: .removeFlower(slotIDs: [slot.id], previousVariants: prevVariants)))
        }
        notifyDelegate()
    }
    
    private func fillRing(_ ring: Int, with flower: FlowerVariant) {
        let ringSlots = slots.filter { $0.ring == ring }
        var affectedIDs: [Int] = []
        var prevVariants: [Int: FlowerVariant?] = [:]
        
        for s in ringSlots {
            affectedIDs.append(s.id)
            prevVariants[s.id] = s.flowerNode?.variant
            s.placeFlower(flower, tint: gameState?.selectedTint ?? .natural)
            playSparkle(at: s.position)
        }
        
        gameState?.pushUndo(UndoAction(type: .placeFlower(slotIDs: affectedIDs, previousVariants: prevVariants)))
        notifyDelegate()
    }
    
    private func placeGridShapeSymmetric(shape: GridShape, at location: CGPoint) {
        let center = CGPoint.zero
        let dx = location.x - center.x
        let dy = location.y - center.y
        let r = hypot(dx, dy)
        let baseAngle = atan2(dy, dx)
        let angleStep = (2 * .pi) / CGFloat(symmetrySlices)
        
        var localOffsets: [CGPoint] = []
        switch shape {
        case .dot:
            localOffsets = [.zero]
        case .line:
            localOffsets = [CGPoint(x: -25, y: 0), .zero, CGPoint(x: 25, y: 0)]
        case .triangle:
            localOffsets = [CGPoint(x: 0, y: 18), CGPoint(x: -16, y: -12), CGPoint(x: 16, y: -12)]
        case .star:
            localOffsets = [CGPoint(x: 0, y: 22), CGPoint(x: -18, y: 5), CGPoint(x: 18, y: 5),
                          CGPoint(x: -12, y: -18), CGPoint(x: 12, y: -18)]
        }
        
        let virtualRing = max(1, Int(r / 60.0) + 1)
        var placedIDs: [Int] = []
        
        for i in 0..<symmetrySlices {
            let sliceAngle = baseAngle + CGFloat(i) * angleStep
            for offset in localOffsets {
                let rotX = offset.x * cos(sliceAngle) - offset.y * sin(sliceAngle)
                let rotY = offset.x * sin(sliceAngle) + offset.y * cos(sliceAngle)
                let bx = r * cos(sliceAngle)
                let by = r * sin(sliceAngle)
                let finalPos = CGPoint(x: bx + rotX, y: by + rotY)
                
                let slot = SlotNode(id: slotIdCounter, ring: virtualRing, angleIndex: i)
                slot.position = finalPos
                worldNode.addChild(slot)
                slots.append(slot)
                placedIDs.append(slotIdCounter)
                slotIdCounter += 1
                playSparkle(at: finalPos)
            }
        }
        
        gameState?.pushUndo(UndoAction(type: .placeGridShape(slotIDs: placedIDs)))
        expandBackgroundIfNeeded()
    }
    
    private func playSparkle(at position: CGPoint) {
        if let emitter = SparkleEmitter.create() {
            emitter.position = position
            emitter.zPosition = 20
            worldNode.addChild(emitter)
            emitter.run(SKAction.sequence([SKAction.wait(forDuration: 0.8), SKAction.removeFromParent()]))
        }
    }
    
    func notifyDelegate() {
        let slotData = slots.map {
            HarmonyScorer.MandalaSlotData(id: $0.id, ring: $0.ring, angleIndex: $0.angleIndex, flower: $0.flowerNode?.variant, tint: $0.flowerNode?.appliedTint ?? .natural)
        }
        onMandalaUpdate?(slotData)
    }
    
    func resetBoard() {
        // Full rebuild — restores initial circle size, rings, slots
        setupBoard()
        gameState?.undoStack.removeAll()
        gameState?.harmonyScore = 0
        gameState?.harmonyFeedback = "A blank garden awaits your creative touch."
        gameState?.currentMoodIcon = "leaf.fill"
        gameState?.currentMoodLabel = "Awaiting"
        gameState?.currentReport = nil
        gameState?.resetSessionMetrics()
        notifyDelegate()
    }
    
    // MARK: - Theme Color Updates
    
    private var lastThemeKey: String = ""
    
    override func update(_ currentTime: TimeInterval) {
        let themeKey = gameState?.selectedGrid ?? "jaipur"
        if themeKey != lastThemeKey {
            lastThemeKey = themeKey
            updateThemeColors()
        }
    }
    
    func updateThemeColors() {
        let theme = CityTheme.forKey(gameState?.selectedGrid ?? "jaipur")
        
        // Background
        bgNode?.fillColor = UIColor(theme.bgColor)
        bgNode?.strokeColor = UIColor(theme.ringColor).withAlphaComponent(0.25)
        
        // Rings
        for ring in ringNodes {
            ring.strokeColor = UIColor(theme.ringColor).withAlphaComponent(0.15)
        }
        
        // Spokes
        for spoke in spokeNodes {
            spoke.strokeColor = UIColor(theme.ringColor).withAlphaComponent(0.06)
        }
        
        // Jali diamonds
        for jali in jaliNodes {
            jali.fillColor = UIColor(theme.ringColor).withAlphaComponent(0.1)
        }
    }
    
    // MARK: - Auto-Expand Background
    
    func expandBackgroundIfNeeded() {
        // Find farthest slot from center
        var maxDist: CGFloat = 0
        for slot in slots {
            let dist = hypot(slot.position.x, slot.position.y)
            maxDist = max(maxDist, dist)
        }
        
        let needed = maxDist + 50 // 50pt padding beyond outermost slot
        guard needed > currentBgRadius else { return }
        
        let theme = CityTheme.forKey(gameState?.selectedGrid ?? "jaipur")
        let ringSpacing: CGFloat = 60.0
        
        // Replace background with larger one
        bgNode?.removeFromParent()
        let newBg = SKShapeNode(circleOfRadius: needed)
        newBg.fillColor = UIColor(theme.bgColor)
        newBg.strokeColor = UIColor(theme.ringColor).withAlphaComponent(0.25)
        newBg.lineWidth = 2
        newBg.zPosition = 0
        newBg.name = "background"
        newBg.setScale(0.9)
        worldNode.addChild(newBg)
        newBg.run(SKAction.scale(to: 1.0, duration: 0.3))
        bgNode = newBg
        
        // Add new ring circles for expanded area
        let existingRingCount = ringNodes.count
        let neededRings = Int(needed / ringSpacing)
        if neededRings > existingRingCount {
            for i in (existingRingCount + 1)...neededRings {
                let radius = CGFloat(i) * ringSpacing
                let ring = SKShapeNode(circleOfRadius: radius)
                ring.fillColor = .clear
                ring.strokeColor = UIColor(theme.ringColor).withAlphaComponent(0.15)
                ring.lineWidth = 1
                ring.zPosition = 1
                ring.alpha = 0
                worldNode.addChild(ring)
                ring.run(SKAction.fadeAlpha(to: 1.0, duration: 0.3))
                ringNodes.append(ring)
            }
        }
        
        currentBgRadius = needed
        
        // Reposition Jali diamonds to new outer edge
        let jaliR = needed - 10
        for (i, jali) in jaliNodes.enumerated() {
            let angle = (2 * .pi / CGFloat(jaliNodes.count)) * CGFloat(i)
            jali.run(SKAction.move(to: CGPoint(x: jaliR * cos(angle), y: jaliR * sin(angle)), duration: 0.3))
        }
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}
