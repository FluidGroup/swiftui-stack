import SwiftUI

public struct StackLink<Label: View, Value: Hashable>: View {
  
  @Environment(\.stackContext) private var context
  
  private let label: Label
  private let value: Value?
  
  public init(value: Value?, @ViewBuilder label: () -> Label) {
    self.label = label()
    self.value = value
  }
  
  public var body: some View {
    Button {
      guard let context else {
        return
      }
      guard let value else {
        return
      }
      
      context.push(value: value)
      
    } label: {
      label
    }
    
  }
}
