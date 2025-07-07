import Foundation

struct UserDTO: Decodable {
  let id: Int
  let name: String
  let profile_picture_url: URL
}

extension UserDTO {
  func mapUser() -> User {
    User(
      id: id,
      name: name,
      picture: profile_picture_url
    )
  }
}
