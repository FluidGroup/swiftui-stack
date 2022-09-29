
public struct StackLookupStragety {
  
  let `where`: (StackIdentifier) -> Bool
  
  public init(`where`: @escaping (StackIdentifier) -> Bool) {
    self.where = `where`
  }
  
  public static func identifiers(_ identifiers: Set<StackIdentifier>) -> Self {
    self.init { i in
      identifiers.contains(i)
    }
  }
  
  public static func identifier(_ identifier: StackIdentifier) -> Self {
    self.init { i in
      i == identifier
    }
  }
   
  public static var current: Self {
    .init { _ in true }
  }
  
  
}

