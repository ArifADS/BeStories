import Foundation


struct StoriesService {
  let persistence: PersistenceManager

  func fetchUsers(page: Int) async throws -> [User] {
    let data = try fetchMock(name: "mock_users")
    let pagedDTOs = try JSONDecoder().decode(PaginatedUsersResponse.self, from: data)
    let dtos = pagedDTOs.pages[safe: page]?.users ?? []
    try await Task.sleep(for: .seconds(1))

    return dtos.map { $0.mapUser() }
  }

  func fetchStories(userId: User.ID) async throws -> [Story] {
    let stories: [Story] = .mocks(user: userId)

    return await persistence.hydratedStories(stories)
  }

  func setSeen(story: Story, user: User) async {
    await persistence.setSeen(story: story, user: user)
  }

  func setLiked(story: Story, user: User) async {
    await persistence.likeStory(story, user: user)
  }
}

private extension StoriesService {
  func fetchMock(name: String) throws -> Data {
    guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
      throw ServiceError.invalidURL
    }
    return try Data(contentsOf: url)
  }
}


private enum ServiceError: Error {
  case invalidURL
}

private struct PaginatedUsersResponse: Decodable {
  let pages: [Page]

  struct Page: Decodable {
    let users: [UserDTO]
  }
}

extension StoriesService {
  static func mock() -> Self {
    .init(persistence: .init())
  }
}

extension [Story] {
  static func mocks(user: User.ID) -> [Story] {
    let initial = user * 10
    let final = initial + 10
    return (initial ..< final).map { id in
      Story(
        id: "\(id)",
        image: URL(string: "https://picsum.photos/seed/\(id)/450/800")!,
        date: Date().addingTimeInterval(-Double(id) * 86400)
      )
    }
  }
}
