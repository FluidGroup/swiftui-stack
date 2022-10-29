import SwiftUI

public struct StackLink<Label: View, Destination: View>: View {
  
  @Environment(\.stackContext) private var context
      
  private let target: StackLookupStragety
  private let label: Label
  private let value: (any Hashable)?
  private let destination: Destination?
  
  private var linkEnvironments: LinkEnvironmentValues = .init()
  
  public init<Value: Hashable>(
    target: StackLookupStragety = .current,
    value: Value?,
    @ViewBuilder label: () -> Label
  ) where Destination == Never {
    self.target = target
    self.label = label()
    self.value = value
    self.destination = nil
  }
  
  public init(
    target: StackLookupStragety = .current,
    @ViewBuilder destination: () -> Destination,
    @ViewBuilder label: () -> Label
  ) {
    self.target = target
    self.label = label()
    self.destination = destination()
    self.value = nil
  }
  
  public var body: some View {
    Button {
      guard let context = context?.lookup(strategy: target) else {
        Log.error(.stack, "Attempted to push view in Stack, but found no context")
        return
      }
      
      if let value {
        context.push(value: value, linkEnvironmentValues: linkEnvironments)
        return
      }
      
      if let destination {
        context.push(destination: destination, linkEnvironmentValues: linkEnvironments)
        return
      }
           
    } label: {
      label
    }
    .disabled(context == nil)
  }
  
  public func setLinkEnvironment<Value>(_ keyPath: WritableKeyPath<LinkEnvironmentValues, Value>, value: Value) -> Self {
    var modified = self
    modified.linkEnvironments[keyPath: keyPath] = value
    return modified
  }
  
}

