import SwiftUI

struct DailyMandalaCanvas: View {
    let theme: CityTheme
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let maxRadius = min(size.width, size.height) / 2 * 0.9
            
            // Generate deterministic but changing pattern based on day
            let cal = Calendar.current
            let dayOfYear = cal.ordinality(of: .day, in: .year, for: Date()) ?? 1
            
            let rings = 3 + (dayOfYear % 3)
            let petals = 6 + (dayOfYear % 6) * 2 // 6, 8, 10, 12, 14, 16
            
            for ring in 0..<rings {
                let radius = maxRadius * (CGFloat(ring + 1) / CGFloat(rings))
                let ringPetals = petals + (ring * 2)
                
                for p in 0..<ringPetals {
                    let angle = (CGFloat(p) / CGFloat(ringPetals)) * 2 * .pi
                    // Rotate inner rings
                    let finalAngle = angle + (CGFloat(dayOfYear % 360) * .pi / 180.0) * (ring % 2 == 0 ? 1 : -1)
                    
                    let x = center.x + cos(finalAngle) * radius
                    let y = center.y + sin(finalAngle) * radius
                    
                    let petalSize = (maxRadius * 0.4) / CGFloat(ring + 1)
                    
                    var path = Path()
                    path.addArc(center: CGPoint(x: x, y: y), radius: petalSize, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
                    
                    context.fill(path, with: .color(theme.accent.opacity(0.3 + (0.1 * CGFloat(ring)))))
                    context.stroke(path, with: .color(theme.accent.opacity(0.8)), lineWidth: 1)
                }
            }
            
            // Center
            var path = Path()
            path.addArc(center: center, radius: maxRadius * 0.15, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
            context.fill(path, with: .color(theme.bgColor))
            context.stroke(path, with: .color(theme.accent), lineWidth: 2)
        }
        .background(Color.black.opacity(0.3))
    }
}
