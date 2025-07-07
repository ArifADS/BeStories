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
