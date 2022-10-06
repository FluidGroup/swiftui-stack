
import SwiftUI

public struct AdditionalSafeArea: UIViewControllerRepresentable {
  
  public typealias UIViewControllerType = UIViewController
  
  private let insets: EdgeInsets
  
  public init(_ insets: EdgeInsets) {
    self.insets = insets
  }
  
  public func makeUIViewController(context: Context) -> UIViewController {
    .init()
  }
  
  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    
    uiViewController.additionalSafeAreaInsets = .init(
      top: insets.top,
      left: insets.leading,
      bottom: insets.bottom,
      right: insets.trailing
    )
    
  }
  
}
