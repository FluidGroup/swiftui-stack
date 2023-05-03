import SwiftUI

/**
 A view that controls a stack presentation

 ```swift
 Stack {

   List {
     StackLink(value: Color.pink) {
       ColorDisplay(color: Color.pink)
     }
   }
   .stackDestination(for: Color.self) { color in
     ColorDetail(color: color)
   }

 }
 ```
*/
public struct StackLink<Label: View, Destination: View, Transition: StackTransition>: View {

  // to trigger update entirely
  @EnvironmentObject private var dummy_context: _StackContext

  @Environment(\.stackContext) private var context
  @Environment(\.stackNamespaceID) private var namespaceID

  /// pushing or not
  @State var isActive = false
  @State var currentIdentifier: _StackedViewIdentifier?

  private let target: StackLookupStragety
  private let label: Label
  private let value: (any Hashable)?
  private let destination: Destination?
  private let transition: Transition

  private var linkEnvironments: LinkEnvironmentValues = .init()

  public init<Value: Hashable>(
    target: StackLookupStragety = .current,
    transition: Transition,
    value: Value?,
    @ViewBuilder label: () -> Label
  ) where Destination == Never {
    self.target = target
    self.label = label()
    self.value = value
    self.destination = nil
    self.transition = transition
  }

  public init<Value: Hashable>(
    target: StackLookupStragety = .current,
    value: Value?,
    @ViewBuilder label: () -> Label
  ) where Destination == Never, Transition == StackTransitions.Basic {
    self.init(
      target: target,
      transition: StackTransitions.Basic(transition: .opacity.animation(.spring())),
      value: value,
      label: label
    )
  }

  public init(
    target: StackLookupStragety = .current,
    transition: Transition,
    @ViewBuilder destination: () -> Destination,
    @ViewBuilder label: () -> Label
  ) {
    self.target = target
    self.label = label()
    self.destination = destination()
    self.value = nil
    self.transition = transition
  }

  public init(
    target: StackLookupStragety = .current,
    @ViewBuilder destination: () -> Destination,
    @ViewBuilder label: () -> Label
  ) where Transition == StackTransitions.Basic {
    self.init(
      target: target,
      transition: StackTransitions.Basic(transition: .opacity.animation(.spring())),
      destination: destination,
      label: label
    )
  }

  // content for label
  public var body: some View {
    Button {

//      guard currentIdentifier == nil else { return }

      guard let context = context?.lookup(strategy: target) else {
        Log.error(.stack, "Attempted to push view in Stack, but found no context")
        return
      }

      // TODO: make this can be customized.
      let transaction = Transaction(animation: .spring(
        response: 0.4,
        dampingFraction: 1,
        blendDuration: 0
      ))

      withTransaction(transaction) {

        if let value {
          let id = context.push(
            value: value,
            transition: transition,
            linkEnvironmentValues: linkEnvironments
          )

          self.currentIdentifier = id
          return
        }

        if let destination {
          let id = context.push(
            destination: destination,
            transition: transition,
            linkEnvironmentValues: linkEnvironments
          )

          self.currentIdentifier = id

          return
        }

      }

    } label: {
      label
        .modifier(transition.labelModifier)
        .environment(\.stackedViewIdentifier, context?.stackedViews.first { $0.id == currentIdentifier }?.id)
    }
    .disabled(context == nil)

  }

  public func linkEnvironment<Value>(
    _ keyPath: WritableKeyPath<LinkEnvironmentValues, Value>,
    value: Value
  ) -> Self {
    var modified = self
    modified.linkEnvironments[keyPath: keyPath] = value
    return modified
  }

}

