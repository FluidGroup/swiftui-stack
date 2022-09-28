import SwiftUI

public struct StackLink<Label: View, Destination: View>: View {
  
  @Environment(\.stackContext) private var context
  
  private let label: Label
  private let value: (any Hashable)?
  private let destination: Destination?
  
  public init<Value: Hashable>(value: Value?, @ViewBuilder label: () -> Label) where Destination == Never {
    self.label = label()
    self.value = value
    self.destination = nil
  }
  
  public init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
    self.label = label()
    self.destination = destination()
    self.value = nil
  }
  
  public var body: some View {
    Button {
      guard let context else {
        Log.error(.stack, "Attempted to push view in Stack, but found no context")
        return
      }
      
      if let value {
        context.push(value: value)
        return
      }
      
      if let destination {
        context.push(destination: destination)
        return
      }
           
    } label: {
      label
    }
    
  }
}
