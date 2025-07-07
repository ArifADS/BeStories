//
//  ContentView.swift
//  BeStories
//
//  Created by Arif De Sousa on 7/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var items: [Item]
  let service = StoriesService()
  @State private var users = [User]()

  var body: some View {
    List {

    }
    .navigationTitle("BeStories")
    .navigationBarTitleDisplayMode(.inline)
    .safeAreaInset(edge: .top) {
      UsersCarousel(users: users)
    }
    .task {
      await fetchUsers()
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
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
