
import SwiftUI

public struct NavigationBar<Class: UINavigationBar>: UIViewRepresentable {
  
  public typealias UIViewType = UINavigationBar
  
  public final class Coordinator: NSObject, UINavigationBarDelegate {
    
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
      return .topAttached
    }
  }
  
  public init() {
    
  }
  
  public func makeCoordinator() -> Coordinator {
    .init()
  }
    
  public func makeUIView(context: Context) -> UINavigationBar {
    let bar = Class.init()
    
    let item = UINavigationItem()
    item.title = "Hello"
    
    bar.pushItem(item, animated: false)
    
    bar.delegate = context.coordinator
    
    return bar
  }
  
  public func updateUIView(_ uiView: UINavigationBar, context: Context) {
    
  }
    
  
}

struct NaviagtionBar_Previews: PreviewProvider {
  static var previews: some View {
    
    VStack {
      NavigationBar()
      Spacer()
    }
  }
}
