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
  @State private var stories: [User.ID: [Story]] = [:]
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
        stories: stories[user.id, default: []],
      )
      .task { await fetchStories(for: user) }
      .environment(\.storyAction, createStoryActions(user: user))
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

  func fetchStories(for user: User) async {
    do {
      let stories = try await service.fetchStories(userId: user.id)
      self.stories[user.id] = stories
    } catch {
      print("Failed to fetch stories for user \(user.id): \(error)")
    }
  }

  func createStoryActions(user: User) -> StoryActions {
    .init(
      onSeen: { story in
        await service.setSeen(story: story, user: user)
      },
      onLiked: { story in
        await service.setLiked(story: story, user: user)
        if let index = self.stories[user.id]?.firstIndex(where: { $0.id == story.id }) {
          self.stories[user.id]?[index].liked.toggle()
        }
      }
    )
  }
}

#Preview {
  ContentView(service: .mock())
}
