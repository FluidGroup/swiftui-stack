import SwiftUIStack
import SwiftUI
import SwiftUISupport
import swiftui_color

extension Color {
  static var appGreen: Color {
    .init(.displayP3, hexInt: 0xced788, opacity: 1)
  }
  static var appPurple: Color {
    .init(.displayP3, hexInt: 0x654ee8, opacity: 1)
  }
  static var appRed: Color {
    .init(.displayP3, hexInt: 0xdb6358, opacity: 1)
  }
}

struct BookStack: View {

  @State var momentA: Bool = false
  @State var momentB: Bool = false

  @Binding var path: StackPath

  @State var counter: Int = 0

  init(path: Binding<StackPath>) {
    self._path = path
  }

  var body: some View {

    VStack {

      StackUnwindLink {
        Text("Back")
      }

      VStack {

        Text("Stack")
          .font(.title)
          .frame(maxWidth: .infinity, alignment: .leading)

        Stack(path: $path) {

          VStack {
            Text("Root")

            StackLink(value: M<A>()) {
              Text("Open A")
            }

            StackLink(value: M<B>()) {
              Text("Open B")
            }
//
//            StackLink(value: M<C>()) {
//              Text("Open C")
//            }

            Button("Toggle Alert A") {
              momentA = true
            }

            Button("Toggle Alert B") {
              momentB = true
            }
          }
          .stackDestination(for: M<A>.self) { model in
            ZStack {
              Color.appPurple

              VStack {
                StatefulPage(title: "\(model)")

                StackLink(value: M<B>()) {
                  Text("Open B")
                }

                StackUnwindLink {
                  Text("Pop")
                }
              }
            }

          }
          .stackDestination(for: M<B>.self) { model in
            ZStack {
              Color.appRed
              VStack {
                Text(String(describing: model))

                StackLink(value: M<A>()) {
                  Text("Open A")
                }

                StackUnwindLink {
                  Text("Pop")
                }
              }
            }
          }

          .stackDestination(isPresented: $momentA) {
            ZStack {
              Color.purple
              VStack {
                Text("Moment A")
                StackUnwindLink {
                  Text("Pop")
                }
              }
            }
          }
          .stackDestination(isPresented: $momentB) {
            ZStack {
              Color.purple
              VStack {
                Text("Moment B")
                StackUnwindLink {
                  Text("Pop")
                }
              }
            }
          }
        }
        .frame(height: 120)
        .background(Color.appGreen)
      }
      .padding(.horizontal, 20)

      VStack {

        Text("Controls")
          .font(.title)
          .frame(maxWidth: .infinity, alignment: .leading)

        VStack {
          Button("\(counter.description)") {
            counter += 1
          }
          Button("Toggle Moment A") {
            momentA.toggle()
          }

          Button("Set 1") {
            path = .init()
            path.append(M<A>(id: "1"))
            path.append(M<B>(id: "2"))
            path.append(M<C>(id: "3"))
          }

          Button("Set 2") {
            path = .init()
            path.append(M<A>(id: "4"))
            path.append(M<B>(id: "5"))
            path.append(M<C>(id: "6"))
          }

          Button("Append") {
            path.append(M<A>(id: "4"))
          }
        }
      }
      .padding(.horizontal, 20)

      VStack {

        Text("Path")
          .font(.title)
          .frame(maxWidth: .infinity, alignment: .leading)

      }
      .padding(.horizontal, 20)
    }
    .background(Color(white: 0, opacity: 0.05))

  }
}

struct BookStack_Previews: PreviewProvider {

  struct Wrap: View {
    @State var path: StackPath = .init()
    var body: some View {
      BookStack(path: $path)
    }
  }

  static var previews: some View {
    Wrap()
  }
}
