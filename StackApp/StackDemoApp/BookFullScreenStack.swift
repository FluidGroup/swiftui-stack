import SwiftUI
import SwiftUIStack
import SwiftUISupport

struct BookFullScreenStack: View, PreviewProvider {

  @State var path: StackPath = .init([
//    Post(
//      id: "slide",
//      artworkImageURL: nil,
//      title: "Push style transition",
//      subTitle: "Supports gesture to pop",
//      body: ""
//    )
  ] as [Post])

  var body: some View {
    Root(path: $path)
  }

  static var previews: some View {
    Self()

    PostDetail(
      colorScheme: .type10,
      post: Post(
        id: "slide",
        artworkImageURL: nil,
        title: "Push style transition",
        subTitle: "Supports gesture to pop",
        body: ""
      )
    )

  }

  private struct ContentFragment: View {

    let colorScheme: ColorScheme

    let users: [Node] = User.generateDummyUsers().map { .user($0) }

    let postsForCarousel: [Post] = [
      Post(
        id: "carousel-1",
        artworkImageURL: nil,
        title: "Carousel",
        subTitle: "Tap to see",
        body: ""
      ),
      Post(
        id: "carousel-2",
        artworkImageURL: nil,
        title: "Carousel",
        subTitle: "Tap to see",
        body: ""
      ),
      Post(
        id: "carousel-3",
        artworkImageURL: nil,
        title: "Carousel",
        subTitle: "Tap to see",
        body: ""
      ),
      Post(
        id: "carousel-4",
        artworkImageURL: nil,
        title: "Carousel",
        subTitle: "Tap to see",
        body: ""
      ),
      Post(
        id: "carousel-5",
        artworkImageURL: nil,
        title: "Carousel",
        subTitle: "Tap to see",
        body: ""
      ),
      Post(
        id: "carousel-6",
        artworkImageURL: nil,
        title: "Carousel",
        subTitle: "Tap to see",
        body: ""
      ),
    ]

    let postsForList: [Post] = [
      Post(
        id: "a",
        artworkImageURL: nil,
        title: "Contextual style transition",
        subTitle: "Tap to see",
        body: ""
      )
    ]

    let dataForSlideTransition = Post(
      id: "slide",
      artworkImageURL: nil,
      title: "Push style transition",
      subTitle: "Supports gesture to pop",
      body: ""
    )

    let postsForGrid: [Post] = [
      Post(
        id: "grid-1",
        artworkImageURL: nil,
        title: "Grid",
        subTitle: "Tap to see",
        body: ""
      ),
      Post(
        id: "grid-2",
        artworkImageURL: nil,
        title: "Grid",
        subTitle: "Tap to see",
        body: ""
      ),
      Post(
        id: "grid-3",
        artworkImageURL: nil,
        title: "Grid",
        subTitle: "Tap to see",
        body: ""
      ),
      Post(
        id: "grid-4",
        artworkImageURL: nil,
        title: "Grid",
        subTitle: "Tap to see",
        body: ""
      ),
    ]

    @Namespace var local

    var body: some View {

      LazyVStack(spacing: 16) {
        //
        // carousel
        ScrollView(.horizontal) {
          LazyHStack {

            ForEach(postsForCarousel) { post in
              StackLink(
                transition: .matched(identifier: post.id.description + "Shaped", in: local),
                value: post
              ) {
                ShapedGridCell(colorScheme: colorScheme, post: post)
              }
            }

          }
          .padding(.horizontal, 16)
        }

        ScrollView(.horizontal) {
          LazyHStack {

            ForEach(postsForCarousel) { post in
              StackLink(
                transition: .matched(identifier: post.id.description + "non", in: local),
                value: post
              ) {
                GridCell(colorScheme: colorScheme, post: post)
              }
            }

          }
          .padding(.horizontal, 16)
        }

        StackLink(transition: .slide, value: dataForSlideTransition) {
          ShapedPostCell(colorScheme: colorScheme, post: dataForSlideTransition)
        }
        .padding(.horizontal, 16)

        LazyVStack {

          ForEach(postsForList) { post in
            StackLink(
              transition: .matched(identifier: post.id.description + "Shaped", in: local),
              value: post
            ) {
              ShapedPostCell(colorScheme: colorScheme, post: post)
            }
          }

        }
        .padding(.horizontal, 16)

        LazyVStack {

          ForEach(postsForList) { post in
            StackLink(
              transition: .matched(identifier: post.id.description + "Non", in: local),
              value: post
            ) {
              PostCell(colorScheme: colorScheme, post: post)
            }
          }

        }
        .padding(.horizontal, 16)

        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {

          ForEach(postsForGrid) { post in
            StackLink(
              transition: .matched(identifier: post.id.description + "Shaped", in: local),
              value: post
            ) {
              ShapedPostCell(colorScheme: colorScheme, post: post)
            }
          }

        }
        .padding(.horizontal, 16)

        LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {

          ForEach(postsForGrid) { post in
            StackLink(
              transition: .matched(identifier: post.id.description + "Non", in: local),
              value: post
            ) {
              PostCell(colorScheme: colorScheme, post: post)
            }
          }

        }
        .padding(.horizontal, 16)

      }
    }
  }

  enum Node: Hashable, Identifiable {
    case user(User)

    var id: String {
      switch self {
      case .user(let user):
        return "user_\(user.id)"
      }
    }

  }

  struct ShapedGridCell: View {
    let colorScheme: ColorScheme
    let post: Post

    var body: some View {

      VStack(alignment: .leading) {
        VStack(spacing: 0) {
          Circle()
            .fill(Color.init(white: 0.5, opacity: 0.3))
            .frame(
              width: 40,
              height: 40,
              alignment: .center
            )
        }
      }
      .padding(12)
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

  struct GridCell: View {
    let colorScheme: ColorScheme
    let post: Post

    var body: some View {

      VStack(alignment: .leading) {
        VStack(spacing: 0) {
          Circle()
            .fill(Color.init(white: 0.5, opacity: 0.3))
            .frame(
              width: 40,
              height: 40,
              alignment: .center
            )
        }
      }
      .padding(12)
    }
  }

  struct ShapedListCell: View {

    let colorScheme: ColorScheme
    let user: User

    var body: some View {

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

  private struct Root: View {

    let colorScheme = ColorScheme.type10

    @Environment(\.stackUnwindContext) var unwindContext

    @State var lastColorScheme = ColorScheme.type10

    @Binding var path: StackPath

    var body: some View {
      ZStack {

        colorScheme.background
          .ignoresSafeArea()

        Stack(path: $path) {

          ScrollView {
            VStack {
              StackUnwindLink(target: .specific(unwindContext)) {
                Text("back to menu")
              }
              ContentFragment(colorScheme: colorScheme)
            }
          }
          .stackDestination(
            for: User.self,
            destination: { user in
              Detail(user: user, colorScheme: .takeOne(except: colorScheme))
            }
          )
          .stackDestination(for: Post.self) { post in
            // not good
            let _ = self.lastColorScheme = ColorScheme.takeOne(except: lastColorScheme)
            PostDetail(colorScheme: .takeOne(except: lastColorScheme), post: post)
          }

        }

      }
    }
  }

  struct Detail: View {

    let user: User
    var colorScheme: ColorScheme

    @Namespace var local

    var body: some View {

      ZStack {

        StackBackground {
          colorScheme.background
        }

        ScrollView {
          VStack {

            Text(user.name)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.paragraph)

            Text(user.age.description)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.paragraph)

            Spacer()

            VStack {

              HStack {
                StackUnwindLink {
                  Text("Back")
                }
                Spacer()
                StackUnwindLink(mode: .all) {
                  Text("Back to Root")
                }
              }

              StackLink(transition: .matched(identifier: user.id, in: local)) {
                Detail(user: user, colorScheme: .takeOne(except: colorScheme))
              } label: {
                ShapedListCell(colorScheme: colorScheme, user: user)
              }

            }
            .padding(.horizontal, 16)

            ContentFragment(colorScheme: colorScheme)
          }
        }
      }

    }

  }

  //  struct Hashed<Value: Equatable, Key: Hashable>: Hashable {
  //
  //    let idKeyPath: KeyPath<Value, Key>
  //    let value: Value
  //
  //    func hash(into hasher: inout Hasher) {
  //      value[keyPath: idKeyPath].hash(into: &hasher)
  //    }
  //
  //    init(_ value: Value, id: KeyPath<Value, Key>) {
  //      self.value = value
  //      self.idKeyPath = id
  //    }
  //
  //  }

  struct Post: Identifiable, Hashable {

    let id: String

    let artworkImageURL: URL?
    let title: String
    let subTitle: String
    let body: String

  }

  struct ShapedPostCell: View {

    let colorScheme: ColorScheme
    let post: Post

    var body: some View {

      VStack(alignment: .leading) {
        HStack(spacing: 12) {
          RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(colorScheme.background)
            .frame(
              width: 40,
              height: 40,
              alignment: .center
            )

          VStack(alignment: .leading) {
            Text(post.title)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.cardHeadline)

            Text(post.subTitle)
              .foregroundColor(colorScheme.cardParagraph)
          }

          Spacer()
        }
      }
      .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 12))
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

  struct PostCell: View {

    let colorScheme: ColorScheme
    let post: Post

    var body: some View {

      VStack(alignment: .leading) {
        HStack(spacing: 12) {
          RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(colorScheme.cardBackground)
            .frame(
              width: 40,
              height: 40,
              alignment: .center
            )

          VStack(alignment: .leading) {
            Text(post.title)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.headline)

            Text(post.subTitle)
              .foregroundColor(colorScheme.paragraph)
          }

          Spacer()
        }
      }
      .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 12))

    }

  }

  struct PostDetail: View {

    let colorScheme: ColorScheme
    let post: Post

    var body: some View {
      ZStack {

        StackBackground {
          colorScheme.background
        }

        ScrollView {
          VStack {

            Text(post.title)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.paragraph)

            Text(post.subTitle)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.paragraph)

            Text(post.body)
              .font(.system(.body, design: .default))
              .foregroundColor(colorScheme.paragraph)

            Spacer()

            StackUnwindLink {
              Text("Back")
            }

            Text("Others")
              .font(.title2)
              .foregroundColor(colorScheme.headline)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal, 16)

            ContentFragment(colorScheme: colorScheme)
          }
        }
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
