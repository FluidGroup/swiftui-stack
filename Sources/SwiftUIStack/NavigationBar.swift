import SwiftUI

public struct NavigationBar<Class: UINavigationBar>: UIViewRepresentable {

  public typealias UIViewType = UINavigationBar

  public final class Coordinator: NSObject, UINavigationBarDelegate {

    let item = UINavigationItem()

    public func position(for bar: UIBarPositioning) -> UIBarPosition {
      print(#function)
      return .topAttached
    }
  }

  public let title: String

  public init(title: String) {
    self.title = title
  }

  public func makeCoordinator() -> Coordinator {
    .init()
  }

  public func makeUIView(context: Context) -> UINavigationBar {

    let bar = Class.init()

    bar.backgroundColor = .red
    bar.barTintColor = .clear
    bar.shadowImage = UIImage()
    bar.isTranslucent = true
    bar.setBackgroundImage(UIImage(), for: .default)

    let coordinator = context.coordinator

    bar.pushItem(coordinator.item, animated: false)

    bar.delegate = context.coordinator

    return bar
  }

  public func updateUIView(_ uiView: UINavigationBar, context: Context) {

    let coordinator = context.coordinator
    coordinator.item.title = title

  }

}

#if DEBUG

struct NaviagtionBar_Previews: PreviewProvider {
  static var previews: some View {

    VStack {
      NavigationBar(title: "My NavigationBar")
      Spacer()
    }
  }
}

#endif
