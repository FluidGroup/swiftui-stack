
import Stack

public struct MyOption: LinkEnvironmentKey {
  
  public static var defaultValue: Void {
    ()
  }
}

extension LinkEnvironmentValues {
  
  public var fluidMyOption: MyOption.Value {
    get { self[MyOption.self] }
    set { self[MyOption.self] = newValue }
  }
  
}

