import GestureVelocity
import SwiftUI
import SwiftUISupport

extension StackTransition where Self == StackTransitions.Matched {

  public static func matched(identifier: any Hashable, in namespace: Namespace.ID? = nil) -> Self {
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

      let identifier: any Hashable

      private var usingNamespace: Namespace.ID? {
        specifiedNamespace ?? stackNamespaceID
      }

      func body(content: Content) -> some View {

        ZStack {
          /// expandable shape to make the frame flexible for matched-geometry
          /// it affects the destination.
          Color.clear
          /// Content
          content
        }
          // for unwind
          .matchedGeometryEffect(
            id: "movement:\(identifier)",
            in: usingNamespace!,
            properties: [.frame],
            isSource: false
          )
          .matchedGeometryEffect(
            id: "mask:\(identifier)",
            in: usingNamespace!,
            properties: [],
            isSource: true
          )
          // for matching frame
          .matchedGeometryEffect(
            id: "frame:\(identifier)",
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

      let specifiedNamespace: Namespace.ID?

      let identifier: any Hashable

      private var usingNamespace: Namespace.ID? {
        specifiedNamespace ?? stackNamespaceID
      }

      func body(content: Content) -> some View {

        ZStack {
          /// expandable shape to make the frame flexible for matched-geometry
          Color.clear

          /// Content
          content
            // needs for unwind. give matchedGeometryEffect control for frame.
            .frame(minWidth: 0, minHeight: 0, alignment: .top)
        }
          .transition(
            AnyTransition.modifier(
              active: StyleModifier(opacity: 0, blurRadius: 0),
              identity: .identity
            )
          )

          // for backwards
          .matchedGeometryEffect(
            id: "movement:\(identifier)",
            in: usingNamespace!,
            properties: [],
            isSource: true
          )

          .modifier(
            ContextualPopModifier()
          )
          .matchedGeometryEffect(
            id: "mask:\(identifier)",
            in: usingNamespace!,
            properties: [.frame],
            isSource: false
          )
          .matchedGeometryEffect(
            id: "frame:\(identifier)",
            in: usingNamespace!,
            properties: [.frame],
            isSource: true
          )
      }

    }

    private struct ContainerView<Content: View>: View {

      private let content: Content
      private let namespace: Namespace.ID
      @Namespace var local

      init(content: Content, namespace: Namespace.ID) {
        self.content = content
        self.namespace = namespace
      }

      var body: some View {
        ZStack {
          Color.purple
          content
            .frame(minWidth: 0, minHeight: 0, alignment: .top)
        }

      }

    }

    public let identifier: any Hashable
    public let specifiedNamespace: Namespace.ID?

    init(identifier: any Hashable, in namespace: Namespace.ID?) {
      self.identifier = identifier
      self.specifiedNamespace = namespace
    }

    public var labelModifier: some ViewModifier {
      _LabelModifier(specifiedNamespace: specifiedNamespace, identifier: identifier)
    }

    public var destinationModifier: some ViewModifier {
      _DestinationModifier(specifiedNamespace: specifiedNamespace, identifier: identifier)
    }

  }
}

private struct ContextualPopModifier: ViewModifier {

  @Environment(\.stackUnwindContext) private var unwindContext

  func body(content: Content) -> some View {
    content
      .modifier(
        VelocityDraggingModifier(
          minimumDistance: 16,
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
