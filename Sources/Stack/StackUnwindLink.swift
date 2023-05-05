import SwiftUI

/**
 A view that controls a stack presentation.
 
 Users click or tap a unwind link to pop the current displaying view inside a ``AbstractStack``.
 */
public struct StackUnwindLink<Label: View>: View {

  /// The option for which ``StackUnwindContext`` should be used.
  public enum Target {
    /// Uses nearest stack's context
    case automatic
    case specific(StackUnwindContext?)
  }

  public enum UnwindMode {
    /// pop one
    case one
    /// pop to root
    case all
  }

  /// It appears if this view is in ``AbstractStack``.
  @Environment(\.stackUnwindContext) private var automaticUnwindContext

  public let target: Target
  public let mode: UnwindMode

  private let label: Label
  private let animation: Animation
  
  public init(
    target: Target = .automatic,
    mode: UnwindMode = .one,
    animation: Animation = .spring(
      response: 0.4,
      dampingFraction: 0.8,
      blendDuration: 0
    ),
    @ViewBuilder label: () -> Label
  ) {
    self.target = target
    self.mode = mode
    self.animation = animation
    self.label = label()
  }
  
  public var body: some View {
    Button {

      var targetUnwindContext: StackUnwindContext? {
        switch target {
        case .automatic:
          return self.automaticUnwindContext
        case .specific(let unwindContext):
          return unwindContext
        }
      }

      guard let targetUnwindContext else {
        // TODO: assertion
        return
      }

      switch mode {
      case .all:
        // FIXME: how to run animation, inheriting specified transition
        withAnimation(animation) {
          targetUnwindContext.popAll()
        }
      case .one:
        // FIXME: how to run animation, inheriting specified transition
        withAnimation(animation) {
          targetUnwindContext.pop()
        }
      }

      
    } label: {
      label
    }
    .disabled(automaticUnwindContext == nil)
    
  }
}

/**
 A context for unwind in a ``AbstractStack``
 */
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

  public func popAll() {
    stackContext.popAll()
  }

}

extension EnvironmentValues {

  /**
   A context for unwind in a ``AbstractStack``
   */
  public var stackUnwindContext: StackUnwindContext? {
    guard let stackContext, let stackIdentifier else { return nil }
    return .init(stackContext: stackContext, stackIdentifier: stackIdentifier)
  }
}
