import GestureVelocity
import SwiftUI
import SwiftUISupport

extension StackTransition where Self == StackTransitions.Matched {

  public static func matched(identifier: some Hashable, in namespace: Namespace.ID? = nil) -> Self {
    .init(identifier: identifier, in: namespace)
  }

}

extension StackTransitions {

  public struct Matched: StackTransition {

    private struct _LabelModifier: ViewModifier {

      /// available in Stack
      @Environment(\.stackNamespaceID) private var stackNamespaceID

      @Environment(\.stackLinkIsActive) private var isActive

      let specifiedNamespace: Namespace.ID?

      let identifier: AnyHashable

      private var usingNamespace: Namespace.ID? {
        specifiedNamespace ?? stackNamespaceID
      }

      func body(content: Content) -> some View {

        ZStack(alignment: .center) {
          /// expandable shape to make the frame flexible for matched-geometry
          /// it affects the destination.
          Color.clear
          /// Content
          content
            .opacity(isActive ? 0 : 1)
            .blur(radius: isActive ? 20 : 0)
        }

        // for unwind
        .matchedGeometryEffect(
          id: "movement".concat(identifier),
          in: usingNamespace!,
          properties: [.frame],
          isSource: false
        )
        .matchedGeometryEffect(
          id: "mask".concat(identifier),
          in: usingNamespace!,
          properties: [],
          isSource: true
        )
        // for matching frame
        .matchedGeometryEffect(
          id: "frame".concat(identifier),
          in: usingNamespace!,
          properties: [.frame],
          isSource: isActive == false
        )

      }
    }

    private struct _DestinationModifier: ViewModifier {

      /// available in Stack
      @Environment(\.stackUnwindContext) var unwindContext

      /// available in Stack
      @Environment(\.stackNamespaceID) private var stackNamespaceID

      @State var appeared = false

      let specifiedNamespace: Namespace.ID?

      let identifier: AnyHashable

      private var usingNamespace: Namespace.ID? {
        specifiedNamespace ?? stackNamespaceID
      }

      func body(content: Content) -> some View {

        ZStack(alignment: .top) {
          /// expandable shape to make the frame flexible for matched-geometry
          Color.clear

          /// Content
          content
//            .modifier(ResizableModifier(isEnabled: true))
            // needs for unwind. give matchedGeometryEffect control for frame.
            .frame(minWidth: 0, minHeight: 0, alignment: .top)
        }

        // for backwards
        .matchedGeometryEffect(
          id: "movement".concat(identifier),
          in: usingNamespace!,
          properties: [],
          isSource: true
        )
        .transition(
          AnyTransition.modifier(
            active: DestinationStyleModifier(
              opacity: 0,
              blurRadius: 0
            ),
            identity: DestinationStyleModifier(
              opacity: 1,
              blurRadius: 0
            )
          )
        )
        .blur(radius: appeared ? 0 : 20)
        .mask(
          RoundedRectangle(cornerRadius: appeared ? UIScreen.main.displayCornerRadius : 4, style: .continuous).fill(Color.black)
        )
        .modifier(
          ContextualPopModifier()
        )
        .matchedGeometryEffect(
          id: "mask".concat(identifier),
          in: usingNamespace!,
          properties: [.frame],
          isSource: false
        )
        .matchedGeometryEffect(
          id: "frame".concat(identifier),
          in: usingNamespace!,
          properties: [.frame],
          isSource: true
        )

        .onAppear {
          withAnimation {
            appeared = true
          }
        }
      }

    }

    public let identifier: AnyHashable
    public let specifiedNamespace: Namespace.ID?

    init(identifier: AnyHashable, in namespace: Namespace.ID?) {
      self.identifier = identifier
      self.specifiedNamespace = namespace
    }

    public func labelModifier() -> some ViewModifier {
      _LabelModifier(specifiedNamespace: specifiedNamespace, identifier: identifier)
    }

    public func destinationModifier(context: DestinationContext) -> some ViewModifier {
      _DestinationModifier(specifiedNamespace: specifiedNamespace, identifier: identifier)
    }

  }

  private struct DestinationStyleModifier: ViewModifier {

    public let opacity: Double
    public let blurRadius: Double

    public init(
      opacity: Double = 1,
      blurRadius: Double = 0
    ) {
      self.opacity = opacity
      self.blurRadius = blurRadius
    }

    func body(content: Content) -> some View {
      content
        .opacity(opacity)
        .blur(radius: blurRadius)
    }

    static var identity: Self {
      .init()
    }

  }
}

private struct ContextualPopModifier: ViewModifier {

  @Environment(\.stackUnwindContext) private var unwindContext

  func body(content: Content) -> some View {
    content
      .modifier(
        VelocityDraggingModifier(
          minimumDistance: 1,
          axis: [.horizontal, .vertical],
          springParameter: .interpolation(mass: 1, stiffness: 80, damping: 13),
          gestureMode: .highPriority,
          handler: .init(onEndDragging: { velocity, offset, contentSize in

            if abs(velocity.dx) > 50 || abs(offset.width) > (contentSize.width / 2) {
              Task { @MainActor in
                withAnimation(
                  .interpolatingSpring(mass: 1, stiffness: 80, damping: 13)
                ) {
                  unwindContext?.pop()
                }
              }
              return .zero
            } else {
              return .zero
            }
          })
        )
      )

  }
}
