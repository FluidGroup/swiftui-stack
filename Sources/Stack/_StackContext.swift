import Combine
import SwiftUI

enum StackingViewNode {
  case value(StackedView, AnyHashable)
  case moment(StackedView)
}

struct TypeKey: Hashable {

  let base: String

  init<T>(_ base: T.Type) {
    self.base = String(reflecting: base)
  }

  init(any base: Any.Type) {
    self.base = String(reflecting: base)
  }
}

@_spi(StackContext)
@MainActor
public final class _StackContext: ObservableObject, Equatable {

  private struct Destination {

    let target: StackLookupStragety
    let _view: (StackPath.ItemBox) -> AnyView

    init(target: StackLookupStragety, view: @escaping (StackPath.ItemBox) -> AnyView) {
      self.target = target
      self._view = view
    }

    func make(item: StackPath.ItemBox) -> AnyView {
      _view(item)
    }

  }

  nonisolated public static func == (lhs: _StackContext, rhs: _StackContext) -> Bool {
    lhs === rhs
  }

  @Published private(set) var stackedViews: [StackedView] = []

  @Published var path: StackPath = .init()

  /// Functions that creates a view associated with type of value.
  private var destinationTable: [TypeKey: Destination] = [:]

  /// the parent context
  private weak var parent: _StackContext?
  let identifier: StackIdentifier

  init(
    identifier: StackIdentifier?
  ) {
    self.identifier = identifier ?? .init("unnamed")
    Log.debug(.stack, "Init \(self)")
  }

  /// Makes a relationship to parent.
  func set(parent: _StackContext?) {
    self.parent = parent
  }

  /**
   Updates current stacked views with given path - Restoring state
   */
  func receivePathUpdates(path: StackPath) {

    let views = path.values
      .map {
        makeStackedView(itemBox: $0, transition: .disabled, linkEnvironmentValues: .init())?.0
      }
      .compactMap { $0 }

    self.stackedViews = views
    self.path = path

  }

  func registerDestination<D: Hashable, Destination: View>(
    for data: D.Type,
    target: StackLookupStragety,
    destination: @escaping (D) -> Destination
  ) {

    let key = TypeKey(D.self)

    guard destinationTable[key] == nil else {
//      Log.debug(
//        .stack,
//        "The destination for \(D.self) is already registered. Currently restricted in overriding."
//      )
      return
    }

    destinationTable[key] = .init(
      target: target,
      view: { itemBox in
        AnyView(destination(itemBox.value as! D))
      }
    )

  }

  private func makeStackedView(
    itemBox: StackPath.ItemBox,
    transition: some StackTransition,
    linkEnvironmentValues: LinkEnvironmentValues
  ) -> (StackedView, StackLookupStragety)? {

    let key = TypeKey(any: itemBox.subjectType)

    guard let destination = destinationTable[key] else {
      Log.error(
        .stack,
        """
❌ Failed to push - Stack could not found a destination for value \(itemBox) from \(key).
Make sure `stackDestination` methods are inside of stack. It won't work if using that from stack like `Stack { ... }.stackDestination`.
"""
      )
      return nil
    }

    let stackedView = StackedView(
      material: .value(itemBox),
      identifier: itemBox.stackedViewIdentifier,
      linkEnvironmentValues: linkEnvironmentValues,
      content: destination.make(item: itemBox).modifier(transition.destinationModifier)
    )

    return (stackedView, destination.target)
  }

  /**
   For value-push
   Returns nil if push was failed
   */
  @discardableResult
  func push<Value: Hashable>(
    value: Value,
    transition: some StackTransition,
    linkEnvironmentValues: LinkEnvironmentValues
  ) -> _StackedViewIdentifier? {

    func _push(itemBox: StackPath.ItemBox) -> StackPath.ItemBox? {

      guard
        let view = makeStackedView(
          itemBox: itemBox,
          transition: transition,
          linkEnvironmentValues: linkEnvironmentValues
        )?.0
      else {
        // failed to push
        return nil
      }

      stackedViews.append(view)

      return itemBox
    }

    let proposedItemBox = StackPath.ItemBox(value)

    guard let itemBox = _push(itemBox: proposedItemBox) else {
      return nil
    }
    // FIXME: Use linkEnvironmentValues
    path.append(itemBox: itemBox)
    return itemBox.stackedViewIdentifier
  }

  /*
   From StackLink, associated with destination
   */
  @discardableResult
  func push(
    destination: some View,
    transition: some StackTransition,
    linkEnvironmentValues: LinkEnvironmentValues
  ) -> _StackedViewIdentifier {
    // TODO: how to validate the desination is already presented

    // FIXME: Use linkEnvironmentValues

    let identifier = _StackedViewIdentifier(id: UUID().uuidString)

    let stackedView = StackedView(
      material: .volatile,
      identifier: identifier,
      linkEnvironmentValues: linkEnvironmentValues,
      content: destination.modifier(transition.destinationModifier)
    )

    stackedViews.append(stackedView)

    return identifier
  }

  /**
   For momentary-push
   */
  func push(
    binding: Binding<Bool>,
    destination: some View,
    linkEnvironmentValues: LinkEnvironmentValues
  ) -> _StackedViewIdentifier {

    // FIXME: Use linkEnvironmentValues

    let identifier = _StackedViewIdentifier(id: UUID().uuidString)

    let stackedView = StackedView(
      material: .moment(binding),
      identifier: identifier,
      linkEnvironmentValues: linkEnvironmentValues,
      content: destination
    )

    stackedViews.append(stackedView)

    return identifier
  }

  func lookup(strategy: StackLookupStragety) -> _StackContext? {

    if strategy.where(identifier) {
      return self
    } else {
      return parent?.lookup(strategy: strategy)
    }

  }

  /**
   Pops a view associated with given identifier.
   Turns off the flag of presenting if its Binding presents.
   */
  public func pop(identifier: _StackedViewIdentifier) {

    stackedViews.removeAll(
      after: { e in
        e.id == identifier
      },
      perform: { e in

        Log.debug(.stack, "Pop => \(e)")

        switch e.material {
        case .value:
          break
        case .moment(let binding):

          // turn off is-presenting binding
          binding.wrappedValue = false

        case .volatile:
          break
        }
      }
    )

    let newPath = stackedViews.reduce(into: StackPath()) { partialResult, view in

      switch view.material {
      case .value(let itemBox):
        partialResult.append(itemBox: itemBox)
      case .moment:
        break
      case .volatile:
        break
      }

    }

    path = newPath

  }

  deinit {
    Log.debug(.stack, "Deinit \(self)")
  }
}

public struct _StackedViewIdentifier: Hashable {

  enum Identifier: Hashable {
    case objectIdentifier(ObjectIdentifier)
    case string(String)
  }

  let id: Identifier

  init(
    id: ObjectIdentifier
  ) {
    self.id = .objectIdentifier(id)
  }

  init(
    id: String
  ) {
    self.id = .string(id)
  }

}

private enum _StackNamespaceIDKey: EnvironmentKey {
  static var defaultValue: Namespace.ID? { nil }
}

private enum _StackedViewNamespaceIDKey: EnvironmentKey {
  static var defaultValue: Namespace.ID? { nil }
}

private enum _StackContextKey: EnvironmentKey {
  static var defaultValue: _StackContext? { nil }
}

private enum _StackFragmentKey: EnvironmentKey {
  static var defaultValue: _StackedViewIdentifier? { nil }
}

extension EnvironmentValues {

  @_spi(StackContext)
  public var stackContext: _StackContext? {
    get { self[_StackContextKey.self] }
    set { self[_StackContextKey.self] = newValue }
  }

  /// A namespace provided by stack
  @_spi(Internal)
  public var stackNamespaceID: Namespace.ID? {
    get { self[_StackNamespaceIDKey.self] }
    set { self[_StackNamespaceIDKey.self] = newValue }
  }

  /// An identifier for stacked view.
  var stackIdentifier: _StackedViewIdentifier? {
    get { self[_StackFragmentKey.self] }
    set { self[_StackFragmentKey.self] = newValue }
  }
}

extension Array {

  mutating func removeAll(after filterClosure: (Element) -> Bool, perform: (Element) -> Void) {

    var found = false

    removeAll { e in

      if found {
        perform(e)
        return true
      }

      let _found = filterClosure(e)

      if _found {
        found = true
        perform(e)
        return true
      } else {
        return false
      }

    }

  }

}
