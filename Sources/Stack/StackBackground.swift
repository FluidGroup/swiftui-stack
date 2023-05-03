import SwiftUI

/**
 A view that displays background view correctly in ``Stack``
 */
public struct StackBackground<Content: View>: View {

  let content: Content
  @Environment(\._safeAreaInsets) var safeAreaInsets

  public init(
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
  }

  public var body: some View {

    let safeAreaInsets = self.safeAreaInsets

    content
      .padding(.top, -safeAreaInsets.top)
      .padding(.bottom, -safeAreaInsets.bottom)
      .padding(.leading, -safeAreaInsets.leading)
      .padding(.trailing, -safeAreaInsets.trailing)
  }

}

