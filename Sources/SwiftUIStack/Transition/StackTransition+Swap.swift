import SwiftUI

extension StackTransitions {
  
  @available(iOS 17, *)
  public struct Swap: StackTransition {
            
    private struct _LabelModifier: ViewModifier {
      
      func body(content: Content) -> some View {
        content
      }
    }
    
    private struct _DestinationModifier: ViewModifier {
      
      func body(content: Content) -> some View {
        content
          .transition(
            _Transition()
          )        
      }
    }
    
    public init() {
      
    }

    public func labelModifier() -> some ViewModifier {
      _LabelModifier()
    }
    
    public func destinationModifier(context: DestinationContext) -> some ViewModifier {
      _DestinationModifier()
    }
    
  }
  
}

@available(iOS 17, *)
private struct _Transition: Transition {

  nonisolated func body(content: Content, phase: TransitionPhase) -> some View {
    content
      .opacity(phase.isIdentity ? 1 : 0)
      .modifier(
        _ScaleEffect(
          scale: .init(
            width: phase.isIdentity ? 1 : 0.9,
            height: phase.isIdentity ? 1 : 0.9
          )
        )
        .ignoredByLayout()
      )
      .blur(radius: {
        switch phase {
        case .willAppear:
          return 4
        case .identity:
          return 0
        case .didDisappear:
          return 4
        }
      }())
  }
  
}

