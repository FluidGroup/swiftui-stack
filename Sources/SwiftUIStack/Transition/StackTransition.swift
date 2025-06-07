import SwiftUI

public struct DestinationContext {

  public enum BackgroundContent {
    case root
    case stacked(_StackedViewIdentifier)
  }

  /// a content that currently displaying on top.
  public let backgroundContent: BackgroundContent

}

public protocol StackTransition {

  associatedtype LabelModifier: ViewModifier
  associatedtype DestinationModifier: ViewModifier

  @MainActor
  func labelModifier() -> LabelModifier
  @MainActor
  func destinationModifier(context: DestinationContext) -> DestinationModifier

}

extension StackTransition where Self == StackTransitions.Disabled {

  public static var disabled: Self {
    .init()
  }

}

extension StackTransition where Self == StackTransitions.Basic {

  public static func basic(transition: AnyTransition) -> Self {
    .init(transition: transition)
  }

}


public enum StackTransitions {
}

extension StackTransitions {

  public struct Disabled: StackTransition {

    private struct _Modifier: ViewModifier {
      func body(content: Content) -> some View {
        content
      }
    }

    public func labelModifier() -> some ViewModifier {
      _Modifier()
    }

    public func destinationModifier(context: DestinationContext) -> some ViewModifier {
      _Modifier()
    }

  }

  public struct Basic: StackTransition {

    private struct _LabelModifier: ViewModifier {
      func body(content: Content) -> some View {
        content
      }
    }

    private struct _DestinationModifier: ViewModifier {

      let transition: AnyTransition

      func body(content: Content) -> some View {
        content
          .transition(transition)
      }
    }

    public let transition: AnyTransition

    init(transition: AnyTransition) {
      self.transition = transition
    }

    public func labelModifier() -> some ViewModifier {
      _LabelModifier()
    }

    public func destinationModifier(context: DestinationContext) -> some ViewModifier {
      _DestinationModifier(transition: transition)
    }

  }

}

private struct _StackLinkIsActive: EnvironmentKey {

  static var defaultValue: Bool {
    return false
  }

}

private struct _StackedViewIdentifierKey: EnvironmentKey {

  static var defaultValue: _StackedViewIdentifier? {
    return nil
  }

}

extension EnvironmentValues {

  public var stackLinkIsActive: Bool {
    stackedViewIdentifier != nil
  }

}


extension EnvironmentValues {

  public var stackedViewIdentifier: _StackedViewIdentifier? {
    get { self[_StackedViewIdentifierKey.self] }
    set { self[_StackedViewIdentifierKey.self] = newValue }
  }

}
