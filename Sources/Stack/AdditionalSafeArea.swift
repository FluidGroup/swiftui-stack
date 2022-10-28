
import SwiftUI

public struct AdditionalSafeArea<Content: View>: UIViewControllerRepresentable {
  
  public typealias UIViewControllerType = UIHostingController<Content>
  
  @Environment(\.layoutDirection) private var layoutDirection
  
  private let insets: EdgeInsets
  private let content: Content
  
  public init(_ insets: EdgeInsets, @ViewBuilder content: () -> Content) {
    self.insets = insets
    self.content = content()
  }
  
  public func makeUIViewController(context: Context) -> UIViewControllerType {
    UIHostingController(rootView: content)
  }
  
  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    uiViewController.additionalSafeAreaInsets = insets.uiEdgeInsets(in: layoutDirection)    
    uiViewController.rootView = content
    
  }
  
}

extension EdgeInsets {
   
  func uiEdgeInsets(in direction: LayoutDirection) -> UIEdgeInsets {
    if direction == .rightToLeft {
      return UIEdgeInsets(top: top, left: trailing, bottom: bottom, right: leading)
    } else {
      return UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
    }
  }
}
