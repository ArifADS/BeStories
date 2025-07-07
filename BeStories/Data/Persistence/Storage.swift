import Foundation

protocol Storage {
  func saveData(_ stories: [StoryData]) throws
  func loadData() throws -> [StoryData]
}


extension UserDefaults: Storage {
  private var storiesKey: String { "stories_data" }

  func saveData(_ stories: [StoryData]) throws {
    let encoder = JSONEncoder()
    let data = try encoder.encode(stories)
    set(data, forKey: storiesKey)
  }

  func loadData() throws -> [StoryData] {
    guard let data = data(forKey: storiesKey) else { return [] }
    let decoder = JSONDecoder()
    return try decoder.decode([StoryData].self, from: data)
  }
}
