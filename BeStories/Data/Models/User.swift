import Foundation

struct User: Identifiable, Hashable {
  let id: Int
  let name: String
  let picture: URL?
}
