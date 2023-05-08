
public struct LinkEnvironmentValues {
  
  private var backing: [TypeKey : Any] = [:]
  
  public subscript<K>(key: K.Type) -> K.Value where K : LinkEnvironmentKey {
    get {
      guard let value = backing[.init(key)] else {
        return K.defaultValue
      }
      
      return value as! K.Value
    }
    set {
      backing[.init(key)] = newValue
    }
  }
  
}

public protocol LinkEnvironmentKey {
  
  associatedtype Value
  
  static var defaultValue: Self.Value { get }
}

extension LinkEnvironmentValues {
  
  
}
