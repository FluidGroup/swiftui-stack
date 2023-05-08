import SwiftUI

/// ``SwiftUI/NavigationPath``
public struct StackPath: Equatable, CustomStringConvertible {

  /**
   The reason why it is class type object is can describe a path including the same value.
   */
  public final class ItemBox: Hashable, Identifiable, CustomReflectable {

    public static func == (lhs: StackPath.ItemBox, rhs: StackPath.ItemBox) -> Bool {
      lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
      ObjectIdentifier(self).hash(into: &hasher)
    }

    public var id: ObjectIdentifier {
      .init(self)
    }

    public var stackedViewIdentifier: _StackedViewIdentifier {
      .init(id: id)
    }

    /// Returns actual value as `any Hashable`.
    /// This can cast into actual concrete type of value.
    public var value: any Hashable {
      storage.base as! any Hashable
    }

    public var subjectType: Any.Type {
      return type(of: value)
    }

    init<Value: Hashable>(_ value: Value) {
      self.storage = .init(value)
    }

    // MARK: CustomReflectable

    public var customMirror: Mirror {
      .init(
        self,
        children: [
          ("id", id),
          ("value", value),
        ],
        displayStyle: .struct,
        ancestorRepresentation: .suppressed
      )
    }

    // MARK: - Private

    /// a type-erase value
    /// using AnyHashable to compatible with Equatable, Hashable
    private let storage: AnyHashable

  }

  public var count: Int { values.count }
  public var isEmpty: Bool { values.isEmpty }

  var values: [ItemBox]

  public init() {
    self.values = []
  }

  public init<S>(_ elements: S) where S: Sequence, S.Element: Hashable {
    self.values = elements.map { .init($0) }
  }

  mutating func append(itemBox: ItemBox) {
    values.append(itemBox)
  }

  public mutating func append<V>(_ value: V) where V: Hashable {
    values.append(.init(value))
  }

  public mutating func removeLast(_ k: Int = 1) {
    values.removeLast(k)
  }

  public var description: String {
    values.map { "\($0.value)" }.joined(separator: "\n-> ")
  }
}
