import SwiftUI
import Combine

// MARK: - View extensions

extension View {

  public func stackDestination<D, C>(
    for data: D.Type,
    target: StackLookupStragety = .current,
    @ViewBuilder destination: @escaping (D) -> C
  ) -> some View where D: Hashable, C: View {

    self.modifier(
      StackEnvironmentModifier(
        withValue: { context in
          guard let context else {
            return
          }
          context.registerDestination(
            for: data.self,
            target: target,
            destination: destination
          )
        }
      )
    )

  }

  public func stackDestination<V>(
    isPresented: Binding<Bool>,
    target: StackLookupStragety = .current,
    @ViewBuilder destination: @escaping () -> V
  ) -> some View where V: View {

    self.modifier(
      StackMomentaryPushModifier(
        isPresented: isPresented,
        destination: destination,
        target: target
      )
    )

  }

}

private struct StackEnvironmentModifier: ViewModifier {

  @Environment(\.stackContext) private var context

  private let _withValue: @MainActor (_StackContext?) -> Void

  init(withValue: @escaping @MainActor (_StackContext?) -> Void) {
    self._withValue = withValue
  }

  func body(content: Content) -> some View {

    // needs for restoreing path in this timing.
    _withValue(context)

    return
      content
      .onAppear {
        // keep to activate modifier.
      }
      .onDisappear {
      }
  }
}

private struct StackMomentaryPushModifier<Destination: View>: ViewModifier {

  @Environment(\.stackContext) private var context

  @Binding var isPresented: Bool

  @State var currentIdentifier: _StackedViewIdentifier?

  let destination: () -> Destination

  let target: StackLookupStragety

  func body(content: Content) -> some View {

    content
      .onChangeWithPrevious(
        of: isPresented,
        emitsInitial: true,
        perform: { isPresented, _ in

          guard let context = context?.lookup(strategy: target) else {
            return
          }

          if isPresented {
            // FIXME: LinkEnvironmentValues
            currentIdentifier = context.push(
              binding: $isPresented,
              destination: destination(),
              linkEnvironmentValues: .init()
            )
          } else {

            if let currentIdentifier {
              self.currentIdentifier = nil
              context.pop(identifier: currentIdentifier)
            }

          }

        }
      )

  }
}
