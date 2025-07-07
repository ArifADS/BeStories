import SwiftUI

struct UsersCarousel: View {
  @Namespace private var safeNamespace
  let users: [User]
  var namespace: Namespace.ID?
  var actions: Actions?
  let isLoading = true


  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 24) {
        ForEach(users) { user in
          UserStoryView(user: user)
            .matchedTransitionSource(id: "zoom_\(user.id)", in: namespace ?? safeNamespace)
            .onTapGesture {
              actions?.onUserSelected(user)
            }
        }

        if isLoading {
          ProgressView()
            .frame(width: 100, height: 100)
        }
      }
      .padding()
    }
    .frame(height: 150)
  }
}

extension UsersCarousel {
  struct Actions {
    let onUserSelected: (User) -> Void
  }
}

#Preview {
  UsersCarousel(users: [
    User(id: 1, name: "John Doe", picture: URL(string: "https://i.pravatar.cc/300?u=1")),
    User(id: 2, name: "Jane Smith", picture: URL(string: "https://i.pravatar.cc/300?u=2")),
    User(id: 3, name: "Alice Johnson", picture: URL(string: "https://i.pravatar.cc/300?u=3"))
  ])
}
