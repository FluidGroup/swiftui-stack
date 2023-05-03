import Stack
import SwiftUI

struct BookFullScreenStack: View, PreviewProvider {
  var body: some View {
    Content()
  }

  static var previews: some View {
    Self()
  }

  private struct Content: View {

    let colorScheme = ColorScheme.type1

    enum Node: Hashable, Identifiable {
      case user(User)

      var id: String {
        switch self {
        case .user(let user):
          return "user_\(user.id)"
        }
      }

    }

    @State var users: [Node] = User.generateDummyUsers().map { .user($0) }
    @Namespace var local

    var body: some View {
      ZStack {

        colorScheme.background
          .ignoresSafeArea()

        Stack {

          ScrollView {
            VStack {

              ForEach(users) { user in
                switch user {
                case .user(let user):

                  StackLink(
                    transition: .matched(identifier: user.id, in: local),
                    value: user
                  ) {
                    Cell(colorScheme: .type1, user: user)

                  }
                  .padding(.horizontal, 16)
                }
              }

//              ForEach(users) { user in
//                switch user {
//                case .user(let user):
//
//                  StackLink(
//                    transition: .slide,
//                    value: user
//                  ) {
//                    Cell(colorScheme: colorScheme, user: user)
//                  }
//                  .padding(.horizontal, 16)
//
//                }
//              }
            }

          }
          .stackDestination(
            for: User.self,
            destination: { user in
              Detail(user: user)
            }
          )

        }

      }
    }
  }

  struct Cell: View {

    let colorScheme: ColorScheme
    let user: User

    var body: some View {
      HStack {
        VStack(alignment: .leading) {
          HStack(spacing: 12) {
            Circle()
              .fill(Color.init(white: 0.5, opacity: 0.3))
              .frame(
                width: 40,
                height: 40,
                alignment: .center
              )

            Text(user.name)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.cardHeadline)

            Text(user.age.description)
              .foregroundColor(colorScheme.cardParagraph)

            Spacer()
          }
        }
        .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
        .background(
          RoundedRectangle(
            cornerRadius: 8,
            style: .continuous
          )
          .fill(
            colorScheme.cardBackground
          )
        )

      }

    }

  }

  struct Detail: View {

    let user: User
    var colorScheme = ColorScheme.type2

    @Namespace var local

    var body: some View {

      ZStack {
        colorScheme.background.ignoresSafeArea()

        ScrollView {
          VStack {
            
            Text(user.name)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.paragraph)
            
            Text(user.age.description)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.paragraph)
            
            Spacer()
            
            StackLink(transition: .matched(identifier: user.id, in: local)) {
              Detail(user: user, colorScheme: .takeOne(except: colorScheme))
            } label: {
              Cell(colorScheme: .type4, user: user)
            }
            
            StackUnwindLink {
              Text("Back")
            }
          }
        }
        .padding(10)
      }

    }

  }

  struct User: Hashable, Identifiable {
    let id: UUID
    let name: String
    let age: Int
    let profileDescription: String

    static func generateDummyUsers() -> [User] {
      return [
        User(
          id: UUID(),
          name: "User 1",
          age: 62,
          profileDescription: "User 1 is an award-winning writer."
        ),
        User(
          id: UUID(),
          name: "User 2",
          age: 47,
          profileDescription: "User 2 is known for her best-selling novels."
        ),
        User(
          id: UUID(),
          name: "User 3",
          age: 42,
          profileDescription: "User 3 is a renowned manga artist."
        ),
        User(
          id: UUID(),
          name: "User 4",
          age: 32,
          profileDescription: "User 4 is a famous travel writer."
        ),
        // Add more users as needed
      ]
    }
  }

}