
import SwiftUI

struct DragRotationModifier: ViewModifier {
    @GestureState private var dragState = DragState.inactive
    @Binding var position: CGPoint
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .offset(
                x: position.x + dragState.translation.width * 0.2,
                y: position.y + dragState.translation.height * 0.2
            )
            .rotation3DEffect(.degrees(Double(dragState.translation.height) * 0.1), axis: (x: 1, y: 0, z: 0), anchor: .center)
            .rotation3DEffect(.degrees(Double(dragState.translation.width) * 0.1), axis: (x: 0, y: 1, z: 0), anchor: .center)
            .rotation3DEffect(.degrees(Double(dragState.translation.width) * 0.1), axis: (x: 0, y: 0, z: 1), anchor: .center)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.2), value: dragState.translation)
            .gesture(
                DragGesture()
                    .updating(
                        $dragState, body: { (value, state, transaction) in
                            state = .dragging(translation: value.translation)
                        }
                    )
                    .onEnded(onDragEnded)
            )
    }
    
    // Potential future update to change views position on screen when drag ends
    private func onDragEnded(value: DragGesture.Value) {
        position.x = 0
        position.y = 0
    }
}
