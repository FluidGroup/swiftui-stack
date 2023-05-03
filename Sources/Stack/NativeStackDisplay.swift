import SwiftUI

/// A view that displays stacked views in all SwiftUI.
public struct NativeStackDisplay<Root: View>: View, StackDisplaying {

  @Environment(\.stackNamespaceID) var namespaceID

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

      ForEach(stackedViews) { view in
        view
          .zIndex(1) // https://sarunw.com/posts/how-to-fix-zstack-transition-animation-in-swiftui/
      }

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)

  }
}
