//
//  ContentView.swift
//  BeStories
//
//  Created by Arif De Sousa on 7/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Namespace private var namespace
  @State private var users = [User]()
  @State private var path = NavigationPath()
  let service: StoriesService

  var body: some View {
    NavigationStack(path: $path) {
      VStack {
        UsersCarousel(
          users: users,
          namespace: namespace,
          actions: .init(
            onUserSelected: { user in
              path.append(ScreenItem.user(user))
            }
          )
        )

        Divider()

        ContentUnavailableView(
          "BeStories",
          systemImage: "person.3.sequence.fill"
        )
      }
      .navigationDestination(for: ScreenItem.self) {
        makeScreen(item: $0)
      }
    }
    .task {
      await fetchUsers()
    }
  }
}

private extension ContentView {
  func makeScreen(item: ScreenItem) -> some View {
    switch item {
    case .user(let user):
      StoryView(
        name: user.name,
        stories: .mocks(user: user.id)
      )
      .navigationTransition(.zoom(sourceID: "zoom_\(user.id)", in: namespace))
      .toolbarVisibility(.hidden, for: .navigationBar)
    }
  }
}


private extension ContentView {
  func fetchUsers() async {
    do {
      self.users = try await service.fetchUsers(page: 0)
    } catch {
      print("Failed to fetch users: \(error)")
    }
  }
}

#Preview {
  ContentView(service: .mock())
}
