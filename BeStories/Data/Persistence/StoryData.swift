import Foundation

struct StoryData: Codable {
  let id: String
  let userID: Int
  let storyID: String
  var liked: Bool
  var seen: Bool
}


actor PersistenceManager {
  var stories: [StoryData]
  let storage: Storage

  init() {
    self.storage = UserDefaults.standard
    self.stories = (try? storage.loadData()) ?? []
  }

  func likeStory(_ story: Story, user: User) {
    if let index = stories.firstIndex(where: { $0.storyID == story.id }) {
      stories[index].seen = true
      stories[index].liked = true
    } else {
      let newStory = StoryData(
        id: UUID().uuidString,
        userID: user.id,
        storyID: story.id,
        liked: true,
        seen: true
      )
      stories.append(newStory)
    }

    do {
      try storage.saveData(stories)
    } catch {
      print("Failed to save stories: \(error)")
    }
  }

  func hydratedStories(_ stories: [Story]) -> [Story] {
    return stories.map {
      guard let persisted = self.stories.first(where: { $0.storyID == $0.id }) else {
        return $0
      }

      var story = $0
      story.liked = persisted.liked
      story.seen = persisted.seen
      return story
    }
  }
}
