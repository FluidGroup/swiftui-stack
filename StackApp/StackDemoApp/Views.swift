import SwiftUIStack
import SwiftUI

struct ModelView<Content: View>: View {

  private let representation: String
  private let color: Color
  private let content: Content

  init<Model>(
    model: Model,
    color: Color,
    @ViewBuilder content: () -> Content
  ) {
    self.representation = String(describing: model)
    self.color = color
    self.content = content()
  }

  @State var isOn = false
  @State var count = 0

  var body: some View {

    VStack {

      Text(representation)
        .foregroundColor(.white)
        .blendMode(.difference)

      Toggle(isOn: $isOn) {
        Text("Toggle")
      }

      Text("\(count.description)")

      Button("Up") {
        count += 1
      }

      content

    }
    .padding(24)
    .background(color)

  }
}

struct ModelView_Previews: PreviewProvider {
  static var previews: some View {
    ModelView(
      model: M<A>.init(),
      color: .purple,
      content: {
        EmptyView()
      }
    )
  }
}
