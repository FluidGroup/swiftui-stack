import SwiftUI

/**
 A view that displays stacked views in all SwiftUI.
 */
public struct NativeStack<Root: View>: View, StackDisplaying {
  
  let root: Root
  let stackedViews: [StackedView]
  
  public init(
    root: Root,
    stackedViews: [StackedView]
  ) {
    self.root = root
    self.stackedViews = stackedViews
  }
  
  public var body: some View {
    ZStack {
      
      VStack {
        root
      }
      
      ForEach(stackedViews) {
        EquatableView(content: $0)
          .zIndex(1)
          .transition(
            .move(edge: .trailing)
          )
      }
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    
  }
}

