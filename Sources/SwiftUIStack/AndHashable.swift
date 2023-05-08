
struct AndHashable<A: Hashable, B: Hashable>: Hashable {

  public let a: A
  public let b: B

  public init(a: A, b: B) {
    self.a = a
    self.b = b
  }
}

extension Hashable {

  func concat(_ other: some Hashable) -> some Hashable {
    AndHashable(a: self, b: other)
  }

}
