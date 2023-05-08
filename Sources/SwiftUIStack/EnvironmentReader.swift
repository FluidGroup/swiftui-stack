import SwiftUI

struct EnvironmentReader<Content: View, Value>: View {

  @Environment var value: Value
  private let content: (Value) -> Content

  init(
    keyPath: KeyPath<EnvironmentValues, Value>,
    @ViewBuilder content: @escaping (Value) -> Content) {
      self._value = Environment(keyPath)
      self.content = content
    }

  var body: some View {
    content(value)
  }

}

