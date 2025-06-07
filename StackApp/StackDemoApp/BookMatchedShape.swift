@_spi(Internal) import SwiftUIStack
import SwiftUI
import SwiftUISnapDraggingModifier
import SwiftUISupport

struct BookMatchedShape: View, PreviewProvider {
  var body: some View {
    __Stack()
  }

  static var previews: some View {
    Self()
  }

  private final class Controller: ObservableObject {

    @Published var details: [AnyView] = []

  }

  private struct Link: View {

    @EnvironmentObject var controller: Controller
    @Environment(\.stackNamespaceID) var local_tmp
    var local: Namespace.ID {
      local_tmp!
    }

    var isActive: Bool {
      controller.details.isEmpty == false
    }

    var body: some View {
      // subject
      let item = ContainerView {

        ZStack {
          ColorScheme.type1.background
          VStack(alignment: .leading) {
            HStack(spacing: 12) {
              Circle()
                .frame(
                  width: 40,
                  height: 40,
                  alignment: .center
                )

              Text("Name")
                .font(.system(.body, design: .default))

              Text("30")
                .font(.system(.body, design: .default))
            }
            .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
          }
          .blur(radius: isActive ? 30 : 0)
        }

      }

      .matchedGeometryEffect(
        id: "movement",
        in: local,
        properties: [.frame],
        isSource: false
      )

      .matchedGeometryEffect(
        id: "frame",
        in: local,
        properties: [.frame],
        isSource: isActive == false
      )
      .onTapGesture {

        withAnimation(
          .interactiveSpring(response: 0.4, dampingFraction: 0.8, blendDuration: 0)
        ) {

          addDetail()

        }
      }
      .zIndex(isActive ? 0 : 1)

      item
    }

    private func addDetail() {
      let destination = ContainerView {
        ZStack {

          ColorScheme.type2.background

          VStack {
            HStack {
              Button("Dismiss") {
              }
            }
            Circle()
              .frame(
                width: 100,
                height: 100,
                alignment: .center
              )

            Circle()
              .frame(
                width: 100,
                height: 100,
                alignment: .center
              )

            Circle()
              .frame(
                width: 100,
                height: 100,
                alignment: .center
              )

            Text("Hello")
          }
        }
      }

      .transition(
        AnyTransition.modifier(
          active: StyleModifier(opacity: 0, blurRadius: 30),
          identity: .identity
        )
      )

      .matchedGeometryEffect(
        id: "movement",
        in: local,
        properties: [],
        isSource: true
      )
//      .modifier(
//        SnapDraggingModifier(
//          springParameter: .interpolation(mass: 1, stiffness: 80, damping: 13),
//          handler: .init(onEndDragging: { velocity, offset, size in
//
//            withAnimation(.interpolatingSpring(mass: 1, stiffness: 80, damping: 13)) {
//              controller.details = []
//            }
//
//            return .zero
//          })
//        )
//      )
      .matchedGeometryEffect(
        id: "frame",
        in: local,
        properties: [.frame],
        isSource: true
      )

      // simulate in Stack
      controller.details.append(AnyView(destination))

    }
  }

  private struct __Stack: View {

    @StateObject var controller = Controller()
    var hasDetail: Bool {
      controller.details.isEmpty == false
    }
    @Namespace var local

    var body: some View {

      ZStack {

        ZStack {

          VStack {

            // accessories
            do {
              RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(ColorScheme.type4.background)
              Spacer()
            }

            // accessories
            do {
              RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(ColorScheme.type4.background)
              Spacer()
            }

            // accessories
            do {
              RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(ColorScheme.type4.background)
              Spacer()
            }

            Link()

            // accessories
            do {
              RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(ColorScheme.type4.background)
              Spacer()
            }

          }

        }

        ForEach.inefficient(items: controller.details) { view in
          view
        }

      }
      .environment(\.stackNamespaceID, local)
      .environmentObject(controller)

    }

  }

  struct ContainerView<Content: View>: View {

    private let content: Content

    init(@ViewBuilder content: () -> Content) {
      self.content = content()
    }

    var body: some View {
      ZStack {
        Color.clear
        content
          .frame(minWidth: 0, minHeight: 0, alignment: .top)
      }
      .clipped()
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(Color.clear)
      )
    }

  }

  enum ContainerView_Preview: PreviewProvider {

    static var previews: some View {

      ContainerView {
        VStack {
          Text("Hello")
          Text("Hello")
          Text("Hello")
          Text("Hello")
          Text("Hello")
        }
      }
      .frame(maxWidth: 100, maxHeight: 40, alignment: .top)

      VStack {
        Text("1")
        Text("2")
        Text("3")
        Text("4")
        Text("5")
      }
      .frame(minWidth: 0, minHeight: 0, idealHeight: 10, maxHeight: 40, alignment: .top)
      .clipped()

    }
  }
}
