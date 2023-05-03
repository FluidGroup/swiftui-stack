import Stack
import SwiftUI
import SwiftUISupport

@available(iOS 14, *)
struct BookStack_Grid: View {

  @State var data: [UserData] = UserData.generateDummyData(count: 50)

  @Environment(\.stackUnwindContext) var unwindContext

  @Namespace var local

  var body: some View {

    Stack {

      ScrollView {

        LazyVStack {

          StackUnwindLink(target: .specific(unwindContext)) {
            Text("Back to Menu")
          }
          
          ForEach(data, id: \.id) { userData in
            makeUserCell(userData: userData)
          }
        }

      }
      .stackDestination(for: UserData.self) { userData in
        UserDetailView(userData: userData, namespace: local)
      }

    }

  }

  fileprivate func makeUserCell(
    userData: UserData
  ) -> some View {
    StackLink(transition: .matched(identifier: userData.id, in: local), value: userData) {
      VStack {
        HStack(spacing: 12) {
          Circle()
            .fill(Color.gray)
            .frame(
              width: 40,
              height: 40,
              alignment: .center
            )
                    .matchedGeometryEffect(id: "\(userData.id)-image", in: local)

          Text(userData.name)
            .font(.system(.body, design: .default))
                    .matchedGeometryEffect(id: "\(userData.id)-name", in: local)

          Spacer()
        }
              .padding(.horizontal, 24)
              .padding(.vertical, 8)
              .background(Color.orange)
      }
    }
  }

  struct UserDetailView: View {
    let userData: UserData

    let namespace: Namespace.ID

    @State var flag = false

    var body: some View {
      ZStack {

        Color.blue.ignoresSafeArea()

        VStack(spacing: 20) {

          StackUnwindLink {
            Text("Back")
          }

          Rectangle()
            .fill(.white)
            .frame(width: 60, height: 60)
            .rotationEffect(flag ? .degrees(0) : .degrees(360))
            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: flag)
            .onAppear {
              flag = true
            }
            .matchedGeometryEffect(id: "\(userData.id)-image", in: namespace)

          Text("User Details")
            .font(.largeTitle)
            .fontWeight(.bold)

          HStack {
            Text("ID:")
              .font(.title2)
              .fontWeight(.bold)
            Spacer()
            Text(userData.id)
              .font(.title2)
              .foregroundColor(.gray)
          }

          HStack {
            Text("Name:")
              .font(.title2)
              .fontWeight(.bold)
            Spacer()
            Text(userData.name)
              .font(.title2)
              .foregroundColor(.gray)
              .matchedGeometryEffect(id: "\(userData.id)-name", in: namespace)
          }

          HStack {
            Text("Age:")
              .font(.title2)
              .fontWeight(.bold)
            Spacer()
            Text("\(userData.age)")
              .font(.title2)
              .foregroundColor(.gray)
          }

          Spacer(minLength: 0)
        }
      }

    }
  }

}

struct UserData: Hashable {

  let id: String
  var name: String
  var age: Int

  static func generateDummyData(count: Int = 50) -> [UserData] {
    let names: [String] = [
      "Alice", "Bob", "Charlie", "David", "Eva", "Frank", "Grace", "Hannah", "Ivan", "Jack",
      "Kelly", "Linda", "Mike", "Nina", "Oscar", "Paul", "Queen", "Rachel", "Steve", "Tracy",
      "Ursula", "Victor", "Wendy", "Xavier", "Yvonne", "Zack",
    ]

    var dummyData: [UserData] = []

    for _ in 0..<count {
      let randomName = names[Int(arc4random_uniform(UInt32(names.count)))]
      let randomLastName = names[Int(arc4random_uniform(UInt32(names.count)))] + "son"
      let randomAge = Int(arc4random_uniform(65)) + 18

      let user = UserData(
        id: UUID().uuidString,
        name: "\(randomName) \(randomLastName)",
        age: randomAge
      )
      dummyData.append(user)
    }

    return dummyData
  }
}

enum Preview_BookStack_Grid: PreviewProvider {

  static var previews: some View {
    BookStack_Grid()
  }
}
