import SwiftUI
import Combine

enum StackingViewNode {
  case value(StackedView, AnyHashable)
  case moment(StackedView)
}

@MainActor
final class _StackContext: ObservableObject {
    
  private struct TypeKey : Hashable {
    
    let base: String
    
    init<T>(_ base: T.Type) {
      self.base = String(reflecting: base)
    }
    
    init(any base: Any.Type) {
      self.base = String(reflecting: base)
    }
  }
  
  @Published private(set) var stackingViews: [StackedView] = []
  
  @Published var path: StackPath = .init()
    
  /// Functions that creates a view associated with type of value.
  private var destinationTable: [TypeKey : (StackPath.ItemBox) -> AnyView] = [:]
  
  init() {
    Log.debug(.stack, "Init \(self)")
  }
  
  func receivePathUpdates(path: StackPath) {
            
    let views = path.values
      .map {
        makeStackedView(itemBox: $0)
      }
      .compactMap { $0 }
    
    stackingViews = views
    
  }
  
  func registerDestination<D: Hashable, Destination: View>(for data: D.Type, destination: @escaping (D) -> Destination) {
    
    let key = TypeKey(D.self)
    
    guard destinationTable[key] == nil else {
      Log.debug(.stack, "The destination for \(D.self) is already registered. Currently restricted in overriding.")
      return
    }
    
    destinationTable[key] = { itemBox in
      AnyView(destination(itemBox.value as! D))
    }
  }
  
  private func makeStackedView(itemBox: StackPath.ItemBox) -> StackedView? {
    
    let key = TypeKey(any: itemBox.subjectType)
    
    guard let destinationBuilder = destinationTable[key] else {
      Log.error(.stack, "Failed to push - Stack could not found a destination for value \(itemBox) from \(key).")
      return nil
    }
    
    let stackedView = StackedView(
      associated: .value(itemBox),
      identifier: .init(id: itemBox.id),
      content: destinationBuilder(itemBox)
    )
    
    return stackedView
  }
      
  private func _push(itemBox: StackPath.ItemBox) {
        
    guard let view = makeStackedView(itemBox: itemBox) else {
      return
    }
   
    withAnimation(.spring()) {
      stackingViews.append(view)
    }
  }
  
  /**
   For value-push
   */
  func push<Value: Hashable>(value: Value) {    
    _push(itemBox: .init(value))
    path.append(value)
  }
  
  /**
   For momentary-push
   */
  func push(binding: Binding<Bool>, destination: some View) -> _StackingIdentifier {
    
    let identifier = _StackingIdentifier(id: UUID().uuidString)
    
    let stackedView = StackedView(
      associated: .moment(binding),
      identifier: identifier,
      content: destination
    )
    
    withAnimation(.spring()) {
      stackingViews.append(stackedView)
    }
    
    return identifier
  }
  
  /**
   Pops a view associated with given identifier.
   Turns off the flag of presenting if its Binding presents.
   */
  func pop(identifier: _StackingIdentifier) {
            
    stackingViews.removeAll(
      after: { e in
        e.id == identifier
      },
      perform: { e in
        
        switch e.associated {
        case .value(let value):
          
          // sync current path
          // TODO: O(n * m)? 😩
          path.values.removeAll(where: { $0 == value})
          
        case .moment(let binding):
          
          // turn off is-presenting binding
          binding.wrappedValue = false
        }
      }
    )
    
  }
  
  deinit {
    Log.debug(.stack, "Deinit \(self)")
  }
}

struct _StackingIdentifier: Hashable {
  
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
  static var defaultValue: _StackingIdentifier? { nil }
}

extension EnvironmentValues {
  
  var stackContext: _StackContext? {
    get { self[_StackContextKey.self] }
    set { self[_StackContextKey.self] = newValue }
  }
  
  var stackIdentifier: _StackingIdentifier? {
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

extension CollectionDifference {
  
  func transform<U>(_ transform: (ChangeElement) -> U) -> CollectionDifference<U> {
    
    let mapped = map { change -> CollectionDifference<U>.Change in
      switch change {
      case .insert(let offset, let element, let associatedWith):
        return .insert(offset: offset, element: transform(element), associatedWith: associatedWith)
      case .remove(let offset, let element, let associatedWith):
        return .remove(offset: offset, element: transform(element), associatedWith: associatedWith)
      }
    }
    
    return .init(mapped)!
    
  }
  
}
