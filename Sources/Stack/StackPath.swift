import SwiftUI

/// ``SwiftUI/NavigationPath``
public struct StackPath: Equatable {

  final class ItemBox: Hashable, Identifiable, CustomReflectable {

    static func == (lhs: StackPath.ItemBox, rhs: StackPath.ItemBox) -> Bool {
      lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
      ObjectIdentifier(self).hash(into: &hasher)
    }

    var id: ObjectIdentifier {
      .init(self)
    }

    private let storage: AnyHashable

    var value: any Hashable {
      storage.base as! any Hashable
    }

    init<Value: Hashable>(_ value: Value) {
      self.storage = .init(value)
    }

    var subjectType: Any.Type {
      return type(of: value)
    }
     
    var customMirror: Mirror {
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

  }

  public var count: Int { values.count }
  public var isEmpty: Bool { values.isEmpty }

  internal(set) var values: [ItemBox]

  public init() {
    self.values = []
  }

  public init<S>(_ elements: S) where S: Sequence, S.Element: Hashable {
    self.values = elements.map { .init($0) }
  }

  public mutating func append<V>(_ value: V) where V: Hashable {
    values.append(.init(value))
  }

  public mutating func removeLast(_ k: Int = 1) {
    values.removeLast(k)
  }

}
