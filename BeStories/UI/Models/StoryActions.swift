import SwiftUI


struct StoryActions {
  let onSeen: (Story) async -> Void
  let onLiked: (Story) async -> Void
}

extension EnvironmentValues {
  @Entry var storyAction = StoryActions(
    onSeen: { _ in },
    onLiked: { _ in }
  )
}
