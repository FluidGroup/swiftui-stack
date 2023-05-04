import SwiftUI

struct IGTabView: View {
  var body: some View {
    TabView {
      IGHomeView()
        .tabItem {
          Image(systemName: "house.fill")
          Text("Home")
        }
      IGSearchView()
        .tabItem {
          Image(systemName: "magnifyingglass")
          Text("Search")
        }
      IGAddPostView()
        .tabItem {
          Image(systemName: "plus.square")
          Text("Add Post")
        }
      IGNotificationsView()
        .tabItem {
          Image(systemName: "heart.fill")
          Text("Notifications")
        }
      IGProfileView()
        .tabItem {
          Image(systemName: "person.fill")
          Text("Profile")
        }
    }
  }
}

struct IGHomeView: View {
  var body: some View {
    Text("Home")
  }
}

struct IGSearchView: View {
  var body: some View {
    Text("Search")
  }
}

struct IGAddPostView: View {
  var body: some View {
    Text("Add Post")
  }
}

struct IGNotificationsView: View {
  var body: some View {
    Text("Notifications")
  }
}

struct IGProfileView: View {
  let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 2), count: 3)

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        // Profile information and settings button can be added here
        LazyVGrid(columns: columns, spacing: 2) {
          ForEach(0..<30, id: \.self) { _ in
            Rectangle()
              .foregroundColor(Color.gray)
              .aspectRatio(1, contentMode: .fit)
          }
        }
        .padding(2)
      }
    }
  }
}

struct IGPhotoDetailView: View {
  @Binding var isPresented: Bool

  var body: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all)
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.gray)
        .frame(width: 300, height: 300)
      VStack {
        Spacer()
        HStack {
          Spacer()
          Button(action: {
            isPresented = false
          }, label: {
            Image(systemName: "xmark.circle.fill")
              .resizable()
              .foregroundColor(.white)
              .frame(width: 30, height: 30)
          })
        }
        Spacer()
      }
      .padding()
    }
  }
}
