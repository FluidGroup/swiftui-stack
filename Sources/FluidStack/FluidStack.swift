
import FluidInterfaceKit
import Stack
import SwiftUI

public struct FluidStack<Root: View>: UIViewControllerRepresentable, StackDisplaying {
  
  public typealias UIViewControllerType = FluidStackController
  
  public func makeUIViewController(context: Context) -> FluidInterfaceKit.FluidStackController {
    .init()
  }
  
  public func updateUIViewController(_ uiViewController: FluidInterfaceKit.FluidStackController, context: Context) {
  
  }
        
  public init(
    root: Root,
    stackedViews: [StackedView]
  ) {
    
  }
}
