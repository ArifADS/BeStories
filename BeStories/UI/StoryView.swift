import SwiftUI

struct StoryView: View {
  @Environment(\.storyAction) private var actions
  @State private var currentIndex: Int = 0
  let name: String
  let stories: [Story]
  var currentStory: Story? { stories[safe: currentIndex] }

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
    .animation(.bouncy, value: currentIndex)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.background)
    .colorScheme(.dark)
  }
}


// MARK: UI
private extension StoryView {
  func storyImage() -> some View {
    let story = stories[safe: currentIndex]

    return AsyncImage(url: story?.image) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } placeholder: {
      ProgressView()
    }
    .id(story?.id ?? "placeholder")
    .transition(.blurReplace)
  }

  func progress() -> some View {
    HStack(spacing: 8) {
      ForEach(stories.indices, id: \.self) { index in
        Capsule()
          .fill(index == currentIndex ? Color.accentColor : Color.gray.opacity(0.5))
          .frame(maxWidth: .infinity)
          .onTapGesture { currentIndex = index }
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
      Button(action: { Task { await actions.onLiked(story) } }) {
        Label(
          title: { Text(story.liked ? "Liked!" : "Like") },
          icon: { Image(systemName: "heart") }
        )
        .labelStyle(.titleAndIcon)
        .symbolVariant(story.liked ? .fill : .none)
      }
      .font(.body)
      .buttonBorderShape(.capsule)
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
