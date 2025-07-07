import SwiftUI

struct UsersCarousel: View {
  let users: [User]


  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 24) {
        ForEach(users) { user in
          UserStoryView(user: user)
        }
      }
      .padding()
    }
  }
}

#Preview {
  UsersCarousel(users: [
    User(id: 1, name: "John Doe", picture: URL(string: "https://i.pravatar.cc/300?u=1")),
    User(id: 2, name: "Jane Smith", picture: URL(string: "https://i.pravatar.cc/300?u=2")),
    User(id: 3, name: "Alice Johnson", picture: URL(string: "https://i.pravatar.cc/300?u=3"))
  ])
}
