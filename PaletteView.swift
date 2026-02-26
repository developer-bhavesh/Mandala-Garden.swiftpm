import SwiftUI

struct PaletteView: View {
    @EnvironmentObject var gameState: GameState
    @Binding var selectedVariant: FlowerVariant?
    @Binding var selectedGridShape: GridShape?
    @State private var mode: Int = 0 // 0=Flowers, 1=Shapes, 2=Tools

    var body: some View {
        GeometryReader { geo in
            let itemSize: CGFloat = geo.size.width < 400 ? 44 : 52
            let theme = gameState.activeTheme
            
            VStack(spacing: 4) {
                // Mode Picker
                Picker("Mode", selection: $mode) {
                    Label("Flowers", systemImage: "leaf.fill").tag(0)
                    Label("Shapes", systemImage: "diamond.fill").tag(1)
                    Label("Tools", systemImage: "wrench.fill").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 12)
                .padding(.top, 4)
                
                if mode == 0 {
                    flowerPalette(itemSize: itemSize, theme: theme)
                } else if mode == 1 {
                    gridPalette(itemSize: itemSize, theme: theme)
                } else {
                    toolsPalette(itemSize: itemSize, theme: theme)
                }
            }
        }
    }
    
    // MARK: - Flowers
    private func flowerPalette(itemSize: CGFloat, theme: CityTheme) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ResourceManager.shared.allFlowers) { variant in
                    let isSelected = selectedVariant?.id == variant.id
                    
                    Button(action: {
                        selectedVariant = isSelected ? nil : variant
                    }) {
                        VStack(spacing: 2) {
                            ZStack {
                                Circle()
                                    .fill(variant.color.opacity(0.12))
                                    .frame(width: itemSize, height: itemSize)
                                
                                if let img = ResourceManager.shared.flowerUIImage(for: variant.type) {
                                    Image(uiImage: img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: itemSize - 6, height: itemSize - 6)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(variant.color)
                                        .frame(width: itemSize - 6, height: itemSize - 6)
                                }
                            }
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? theme.accent : Color.clear, lineWidth: 2.5)
                                    .frame(width: itemSize, height: itemSize)
                            )
                            
                            Text(variant.type.rawValue)
                                .font(.custom("Georgia", size: 8))
                                .foregroundColor(AppColors.deepMaroon.opacity(0.6))
                        }
                        .padding(3)
                        .background(isSelected ? theme.accent.opacity(0.1) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
                
                // Tint indicator when flower selected
                if selectedVariant != nil {
                    Divider().frame(height: 40)
                    
                    ForEach(FlowerTint.allCases) { tint in
                        let isActive = gameState.selectedTint == tint
                        Button(action: { gameState.selectedTint = tint }) {
                            VStack(spacing: 2) {
                                Circle()
                                    .fill(tint.tintColor)
                                    .frame(width: itemSize * 0.6, height: itemSize * 0.6)
                                    .overlay(
                                        Circle().stroke(isActive ? theme.accent : Color.gray.opacity(0.3), lineWidth: isActive ? 2 : 1)
                                    )
                                Text(tint.rawValue)
                                    .font(.custom("Georgia", size: 7))
                                    .foregroundColor(AppColors.deepMaroon.opacity(0.5))
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
        }
    }
    
    // MARK: - Grid Shapes
    private func gridPalette(itemSize: CGFloat, theme: CityTheme) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(GridShape.allCases) { shape in
                    let isSelected = selectedGridShape == shape
                    
                    Button(action: {
                        selectedGridShape = isSelected ? nil : shape
                    }) {
                        VStack(spacing: 2) {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: itemSize, height: itemSize)
                                Image(systemName: iconFor(shape))
                                    .font(.system(size: itemSize * 0.4))
                                    .foregroundColor(theme.accent)
                            }
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? theme.accent : Color.clear, lineWidth: 2.5)
                            )
                            
                            Text(shape.rawValue)
                                .font(.custom("Georgia", size: 8))
                                .foregroundColor(AppColors.deepMaroon.opacity(0.6))
                        }
                        .padding(3)
                        .background(isSelected ? theme.accent.opacity(0.1) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
        }
    }
    
    // MARK: - Tools
    private func toolsPalette(itemSize: CGFloat, theme: CityTheme) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(PaletteTool.allCases) { tool in
                    let isActive = gameState.activeTool == tool
                    
                    Button(action: {
                        gameState.activeTool = isActive ? nil : tool
                    }) {
                        VStack(spacing: 2) {
                            ZStack {
                                Circle()
                                    .fill(isActive ? theme.accent.opacity(0.2) : Color.gray.opacity(0.1))
                                    .frame(width: itemSize, height: itemSize)
                                Image(systemName: tool.icon)
                                    .font(.system(size: itemSize * 0.4))
                                    .foregroundColor(isActive ? theme.accent : AppColors.deepMaroon.opacity(0.6))
                            }
                            .overlay(
                                Circle()
                                    .stroke(isActive ? theme.accent : Color.clear, lineWidth: 2.5)
                            )
                            
                            Text(tool.rawValue)
                                .font(.custom("Georgia", size: 8))
                                .foregroundColor(AppColors.deepMaroon.opacity(0.6))
                        }
                        .padding(3)
                    }
                    .buttonStyle(.plain)
                }
                
                // Undo button
                Divider().frame(height: 40)
                
                Button(action: {
                    // Undo will be handled by GameView via notification
                    NotificationCenter.default.post(name: .undoAction, object: nil)
                }) {
                    VStack(spacing: 2) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: itemSize, height: itemSize)
                            Image(systemName: "arrow.uturn.backward")
                                .font(.system(size: itemSize * 0.4))
                                .foregroundColor(AppColors.deepMaroon.opacity(0.6))
                        }
                        Text("Undo")
                            .font(.custom("Georgia", size: 8))
                            .foregroundColor(AppColors.deepMaroon.opacity(0.6))
                    }
                    .padding(3)
                }
                .buttonStyle(.plain)
                .disabled(gameState.undoStack.isEmpty)
                .opacity(gameState.undoStack.isEmpty ? 0.4 : 1.0)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
        }
    }
    
    private func iconFor(_ shape: GridShape) -> String {
        switch shape {
        case .dot: return "smallcircle.filled.circle"
        case .line: return "line.diagonal"
        case .triangle: return "triangle.fill"
        case .star: return "star.fill"
        }
    }
}

// Notification for undo
extension Notification.Name {
    static let undoAction = Notification.Name("MandalaUndoAction")
}
