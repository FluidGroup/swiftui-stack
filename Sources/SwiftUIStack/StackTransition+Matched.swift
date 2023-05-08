import SwiftUI
import SwiftUISnapDraggingModifier
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

        let base = Color.clear.hidden()
          .overlay(
            /// Content
            content
            //              .frame(width: targetSize.width, height: targetSize.height, alignment: .center)
            //              .modifier(ResizableModifier(isEnabled: true))
              .opacity(isActive ? 0 : 1)
              .blur(radius: isActive ? 10 : 0)
          )

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

        ZStack {
          /// to make bounds
          /// actual content is displaying as overlay for center alignment in transition.
          content
            .hidden()

          base
        }

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

      @State var targetSize: CGSize = .zero

      private var usingNamespace: Namespace.ID? {
        specifiedNamespace ?? stackNamespaceID
      }

      func body(content: Content) -> some View {

        let base = ZStack(alignment: .top) {
          /// expandable shape to make the frame flexible for matched-geometry
          Color.clear

          /// Content
          content
          // to have constrained size if it's neutral sizing view.
            .frame(width: targetSize.width, height: targetSize.height)
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
        .blur(radius: appeared ? 0 : 10)
        .mask(
          RoundedRectangle(
            cornerRadius: appeared ? 0 : 8,
            style: .continuous
          ).fill(Color.black)
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

        ZStack {

          Color.clear
            .measureSize($targetSize)
            .hidden()

          base

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

  @State var isTracking = false

  func body(content: Content) -> some View {
    content
      .mask(
        RoundedRectangle(
          cornerRadius: isTracking ? 8 : 0,
          style: .continuous
        ).fill(Color.black)
      )
      .modifier(
        SnapDraggingModifier(
          activation: .init(minimumDistance: 20, regionToActivate: .edge([.horizontal])),
          axis: [.horizontal, .vertical],
          springParameter: .interpolation(mass: 2, stiffness: 200, damping: 32),
          gestureMode: .highPriority,
          handler: .init(
            onStartDragging: {
              isTracking = true
            },
            onEndDragging: { velocity, offset, contentSize in

              isTracking = false

            if abs(velocity.dx) > 50 || abs(offset.width) > (contentSize.width / 2) {
              Task { @MainActor in
                withAnimation(
                  .interpolatingSpring(mass: 2, stiffness: 200, damping: 32)
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
