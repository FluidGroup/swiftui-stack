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

  func body(content: Content, phase: TransitionPhase) -> some View {
    content
      .opacity(phase.isIdentity ? 1 : 0)
      .blur(radius: {
        switch phase {
        case .willAppear:
          return 30
        case .identity:
          return 0
        case .didDisappear:
          return 30
        }
      }())
  }
  
}
