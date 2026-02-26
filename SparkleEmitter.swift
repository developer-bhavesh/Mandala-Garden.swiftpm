import SpriteKit

class SparkleEmitter {
    @MainActor
    static func create() -> SKEmitterNode? {
        // Since we are not using an SKS file to avoid bundle issues,
        // we construct the emitter programmatically.
        let emitter = SKEmitterNode()
        
        // Use a simple pixel texture
        let size = CGSize(width: 4, height: 4)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let tex = SKTexture(image: img)
        tex.filteringMode = .nearest
        emitter.particleTexture = tex
        
        emitter.particleBirthRate = 80
        emitter.numParticlesToEmit = 40
        emitter.particleLifetime = 0.5
        emitter.particleLifetimeRange = 0.2
        emitter.particlePositionRange = CGVector(dx: 30, dy: 30)
        
        emitter.particleSpeed = 50
        emitter.particleSpeedRange = 20
        emitter.emissionAngle = 0
        emitter.emissionAngleRange = .pi * 2
        
        emitter.particleAlpha = 1.0
        emitter.particleAlphaSpeed = -2.0
        
        emitter.particleScale = 1.0
        emitter.particleScaleRange = 0.5
        emitter.particleScaleSpeed = -1.0
        
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColorSequence = SKKeyframeSequence(keyframeValues: [
            UIColor(AppColors.deepMaroon),
            UIColor(AppColors.royalGold),
            UIColor(AppColors.jaipurPink),
            UIColor.clear
        ], times: [0.0, 0.3, 0.7, 1.0])
        
        return emitter
    }
}
