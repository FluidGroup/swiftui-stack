import SwiftUI

/**
 A view that controls a stack presentation.
 
 Users click or tap a unwind link to pop the current displaying view inside a ``Stack``.
 */
public struct StackUnwindLink<Label: View>: View {
  
  @Environment(\.stackContext) private var context
  @Environment(\.stackIdentifier) private var identifier
  
  private let label: Label
  private let animation: Animation
  
  public init(
    animation: Animation = .spring(
      response: 0.4,
      dampingFraction: 0.8,
      blendDuration: 0
    ),
    @ViewBuilder label: () -> Label
  ) {
    self.animation = animation
    self.label = label()
  }
  
  public var body: some View {
    Button {
      
      guard let context, let identifier else {
        // TODO: assertion
        return
      }
      
      withAnimation(animation) {
        context.pop(identifier: identifier)
      }
      
    } label: {
      label
    }
    .disabled(context == nil)
    
  }
}

