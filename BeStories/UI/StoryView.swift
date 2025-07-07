import SwiftUI

struct StoryView: View {
  let name: String
  let stories: [Story]
  @State private var currentIndex: Int = 0

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      storyImage()
    }
    .safeAreaInset(edge: .top) {
      VStack {
        progress()
        dateTimeView()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.background)
    .onTapGesture {
      withAnimation { nextStoryTapped() }
    }
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
    stories: [
    Story(
      id: "1",
      image: URL(string: "https://picsum.photos/seed/1/900/1600")!,
      date: Date()
    ),
    Story(
      id: "2",
      image: URL(string: "https://picsum.photos/seed/2/800/600")!,
      date: Date().addingTimeInterval(-86400)
    ),
    Story(
      id: "3",
      image: URL(string: "https://picsum.photos/seed/3/800/600")!,
      date: Date().addingTimeInterval(-172800)
    ),
    Story(
      id: "4",
      image: URL(string: "https://picsum.photos/seed/4/800/600")!,
      date: Date().addingTimeInterval(-259200)
    ),
    Story(
      id: "5",
      image: URL(string: "https://picsum.photos/seed/5/800/600")!,
      date: Date().addingTimeInterval(-345600)
    ),
    Story(
      id: "6",
      image: URL(string: "https://picsum.photos/seed/6/800/600")!,
      date: Date().addingTimeInterval(-432000)
    )
  ])
}
