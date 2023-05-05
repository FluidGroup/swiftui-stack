import GestureVelocity
import SwiftUI
import SwiftUISupport

extension StackTransition where Self == StackTransitions.Slide {

  public static var slide: Self {
    .init()
  }

}

extension StackTransitions {

  public struct Slide: StackTransition {

    private struct _LabelModifier: ViewModifier {

      func body(content: Content) -> some View {
        content
      }
    }

    private struct _DestinationModifier: ViewModifier {

      let context: DestinationContext

      @Environment(\.stackNamespaceID) var stackNamespace

      /// available in Stack
      @Environment(\.stackUnwindContext) var unwindContext

      private func effectIdentifier() -> MatchedGeometryEffectIdentifiers.EdgeTrailing {
        switch context.backgroundContent {
        case .root:
          return .init(content: .root)
        case .stacked(let id):
          return .init(content: .stacked(id))
        }
      }


      func body(content: Content) -> some View {

        content
          .matchedGeometryEffect(
            id: effectIdentifier(),
            in: stackNamespace!,
            properties: .frame,
            anchor: .leading,
            isSource: true
          )
          .transition(
            .move(edge: .trailing).animation(
              .spring(response: 0.6, dampingFraction: 1, blendDuration: 0)
            )
          )
          .modifier(
            VelocityDraggingModifier(
              minimumDistance: 20,
              axis: .horizontal,
              horizontalBoundary: .init(min: 0, max: .infinity, bandLength: 0),
              springParameter: .interpolation(mass: 1.0, stiffness: 500, damping: 500),
              gestureMode: .highPriority,
              handler: .init(onEndDragging: { velocity, offset, contentSize in

                print(velocity, offset, contentSize)

                if velocity.dx > 50 || offset.width > (contentSize.width / 2) {

                  // waiting for animation to complete
                  Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 300_000_000)
                    unwindContext?.pop()
                  }

                  return .init(width: contentSize.width, height: 0)
                } else {
                  return .zero
                }
              })
            )
          )
      }
    }

    public func labelModifier() -> some ViewModifier {
      _LabelModifier()
    }

    public func destinationModifier(context: DestinationContext) -> some ViewModifier { 
      _DestinationModifier(context: context)
    }
  }

}
