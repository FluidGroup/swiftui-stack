import Combine
import SwiftUI

enum StackingViewNode {
  case value(StackedView, AnyHashable)
  case moment(StackedView)
}

@_spi(StackContext)
@MainActor
public final class _StackContext: ObservableObject, Equatable {

  private struct TypeKey: Hashable {

    let base: String

    init<T>(_ base: T.Type) {
      self.base = String(reflecting: base)
    }

    init(any base: Any.Type) {
      self.base = String(reflecting: base)
    }
  }
  
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

  private weak var parent: _StackContext?
  let identifier: StackIdentifier

  init(
    identifier: StackIdentifier?
  ) {
    self.identifier = identifier ?? .init("unnamed")
    Log.debug(.stack, "Init \(self)")
  }

  func set(parent: _StackContext?) {
    self.parent = parent
  }

  func receivePathUpdates(path: StackPath) {

    let views = path.values
      .map {
        makeStackedView(itemBox: $0)?.0
      }
      .compactMap { $0 }

    stackedViews = views

  }

  func registerDestination<D: Hashable, Destination: View>(
    for data: D.Type,
    target: StackLookupStragety,
    destination: @escaping (D) -> Destination
  ) {

    let key = TypeKey(D.self)

    guard destinationTable[key] == nil else {
      Log.debug(
        .stack,
        "The destination for \(D.self) is already registered. Currently restricted in overriding."
      )
      return
    }

    destinationTable[key] = .init(
      target: target,
      view: { itemBox in
        AnyView(destination(itemBox.value as! D))
      }
    )
  }

  private func makeStackedView(itemBox: StackPath.ItemBox) -> (StackedView, StackLookupStragety)? {

    let key = TypeKey(any: itemBox.subjectType)

    guard let destination = destinationTable[key] else {
      Log.error(
        .stack,
        "Failed to push - Stack could not found a destination for value \(itemBox) from \(key)."
      )
      return nil
    }

    let stackedView = StackedView(
      associated: .value(itemBox),
      identifier: .init(id: itemBox.id),
      content: destination.make(item: itemBox)
    )
        
    return (stackedView, destination.target)
  }

  @discardableResult
  private func _push(itemBox: StackPath.ItemBox) -> _StackedViewIdentifier? {

    guard let view = makeStackedView(itemBox: itemBox)?.0 else {
      return nil
    }

    withAnimation(.spring()) {
      stackedViews.append(view)
    }

    return view.id
  }

  /**
   For value-push
   */
  @discardableResult
  func push<Value: Hashable>(value: Value) -> _StackedViewIdentifier? {
    guard let id = _push(itemBox: .init(value)) else {
      return nil
    }
    path.append(value)
    return id
  }

  @discardableResult
  func push(destination: some View) -> _StackedViewIdentifier {

    let identifier = _StackedViewIdentifier(id: UUID().uuidString)

    let stackedView = StackedView(
      associated: .volatile,
      identifier: identifier,
      content: destination
    )

    withAnimation(.spring()) {
      stackedViews.append(stackedView)
    }

    return identifier
  }

  /**
   For momentary-push
   */
  func push(binding: Binding<Bool>, destination: some View) -> _StackedViewIdentifier {

    let identifier = _StackedViewIdentifier(id: UUID().uuidString)

    let stackedView = StackedView(
      associated: .moment(binding),
      identifier: identifier,
      content: destination
    )

    withAnimation(.spring()) {
      stackedViews.append(stackedView)
    }

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

        switch e.associated {
        case .value(let value):

          // sync current path
          // TODO: O(n * m)? 😩
          path.values.removeAll(where: { $0 == value })

        case .moment(let binding):

          // turn off is-presenting binding
          binding.wrappedValue = false

        case .volatile:
          break
        }
      }
    )

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

struct _StackContextKey: EnvironmentKey {
  static var defaultValue: _StackContext? { nil }
}

struct _StackFragmentKey: EnvironmentKey {
  static var defaultValue: _StackedViewIdentifier? { nil }
}

extension EnvironmentValues {

  @_spi(StackContext)
  public var stackContext: _StackContext? {
    get { self[_StackContextKey.self] }
    set { self[_StackContextKey.self] = newValue }
  }

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
