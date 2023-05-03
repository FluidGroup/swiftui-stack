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

      /// available in Stack
      @Environment(\.stackUnwindContext) var unwindContext

      func body(content: Content) -> some View {
        content
          .transition(
            .move(edge: .trailing).animation(
              .spring(response: 0.6, dampingFraction: 1, blendDuration: 0)
            )
          )
          .modifier(
            VelocityDraggingModifier(
              axis: .horizontal,
              horizontalBoundary: .init(min: 0, max: .infinity, bandLength: 0),
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

    public var labelModifier: some ViewModifier {
      _LabelModifier()
    }

    public var destinationModifier: some ViewModifier {
      _DestinationModifier()
    }
  }

}
