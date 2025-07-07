import Foundation

struct Story {
  let id: String
  let image: URL
  let date: Date
  var liked: Bool = false
  var seen: Bool = false
}
