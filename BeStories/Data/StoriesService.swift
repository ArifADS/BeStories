import Foundation


// TODO: Use safe index
struct StoriesService {

  func fetchUsers(page: Int) async throws -> [User] {
    let data = try fetchMock(name: "mock_users")
    let pagedDTOs = try JSONDecoder().decode(PaginatedUsersResponse.self, from: data)
    let dtos = pagedDTOs.pages[page].users
    try await Task.sleep(for: .seconds(1))

    return dtos.map { $0.mapUser() }
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
