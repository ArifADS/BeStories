import SwiftUI

struct StoryView: View {
  let name: String
  let stories: [Story]
  var currentStory: Story? { stories[safe: currentIndex] }
  @State private var currentIndex: Int = 0

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
      storyImage()
        .overlay { navigationButtons() }
      Spacer()
    }
    .safeAreaInset(edge: .top) {
      VStack {
        progress()
        dateTimeView()
      }
    }
    .safeAreaInset(edge: .bottom) {
      if let currentStory { likeButtons(story: currentStory) }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.background)
    .colorScheme(.dark)
  }
}


// MARK: UI
private extension StoryView {
  func storyImage() -> some View {
    AsyncImage(url: stories[safe: currentIndex]?.image) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } placeholder: {
      ProgressView()
    }
  }

  func progress() -> some View {
    HStack(spacing: 8) {
      ForEach(stories.indices, id: \.self) { index in
        Capsule()
          .fill(index == currentIndex ? Color.accentColor : Color.gray.opacity(0.5))
          .frame(maxWidth: .infinity)
      }
    }
    .frame(height: 8)
    .padding(.horizontal)
  }

  func dateTimeView() -> some View {
    let date = stories[safe: currentIndex]?.date ?? .now

    return HStack {
      Text(name).foregroundStyle(.primary).font(.headline)
      Spacer()
      Text(date, style: .time).foregroundStyle(.secondary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal)
  }

  func likeButtons(story: Story) -> some View {
    HStack(spacing: 16) {
      Spacer()
      Button(action: {}) {
        Image(systemName: "heart")
          .symbolVariant(story.isLiked ? .fill : .none)
      }
      .font(.title2)
      .buttonBorderShape(.circle)
      .buttonStyle(.borderedProminent)
      .tint(.red)
    }
    .padding(.horizontal)
  }

  func navigationButtons() -> some View {
    HStack {
      Button(
        action: { currentIndex -= 1 },
        label: { Rectangle().fill(.clear) }
      )
      .disabled(currentIndex == 0)

      Button(
        action: { nextStoryTapped() },
        label: { Rectangle().fill(.clear) }
      )
    }
    .padding(.horizontal)
  }
}

// MARK: - Formatting
private extension StoryView {
  func nextStoryTapped() {
    if currentIndex < stories.count - 1 {
      currentIndex += 1
    } else {
      currentIndex = 0
    }
  }
}


#Preview {
  StoryView(
    name: "Mr Anderson",
    stories: .mocks(user: 0)
  )
}

extension [Story] {
  static func mocks(user: User.ID) -> [Story] {
    let initial = user * 10
    let final = initial + 10
    return (initial ..< final).map { id in
      Story(
        id: "\(id)",
        image: URL(string: "https://picsum.photos/seed/\(id)/450/800")!,
        date: Date().addingTimeInterval(-Double(id) * 86400),
        isLiked: id.isMultiple(of: 2)
      )
    }
  }
}
