import SwiftUI

/**
 A view that controls a stack presentation.
 
 Users click or tap a unwind link to pop the current displaying view inside a ``Stack``.
 */
public struct StackUnwindLink<Label: View>: View {

  @Environment(\.stackUnwindContext) private var unwindContext

  private let label: Label
  private let animation: Animation
  
  public init(
    animation: Animation = .spring(
      response: 0.4,
      dampingFraction: 0.8,
      blendDuration: 0
    ),
    @ViewBuilder label: () -> Label
  ) {
    self.animation = animation
    self.label = label()
  }
  
  public var body: some View {
    Button {
      
      guard let unwindContext else {
        // TODO: assertion
        return
      }

      // FIXME: how to run animation, inheriting specified transition
      withAnimation(animation) {
        unwindContext.pop()
      }
      
    } label: {
      label
    }
    .disabled(unwindContext == nil)
    
  }
}

@MainActor
public struct StackUnwindContext {

  private let stackContext: _StackContext
  private let stackIdentifier: _StackedViewIdentifier

  nonisolated init(stackContext: _StackContext, stackIdentifier: _StackedViewIdentifier) {
    self.stackContext = stackContext
    self.stackIdentifier = stackIdentifier
  }

  public func pop() {
    stackContext.pop(identifier: stackIdentifier)
  }

}

extension EnvironmentValues {

  public var stackUnwindContext: StackUnwindContext? {
    guard let stackContext, let stackIdentifier else { return nil }
    return .init(stackContext: stackContext, stackIdentifier: stackIdentifier)
  }
}
