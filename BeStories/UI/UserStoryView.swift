import SwiftUI

struct UserStoryView: View {
  let picture: URL?
  let name: String

  var body: some View {
    VStack(spacing: 16) {
      AsyncImage(url: picture) { image in
        image.resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 100, height: 100)
          .clipShape(Circle())
      } placeholder: {
        VStack {
          Image(systemName: "person.crop.circle.fill")
            .resizable()
            .foregroundStyle(.secondary)
            .frame(width: 100, height: 100)
        }
      }


      Text(name)
        .font(.subheadline)
    }
  }
}


extension UserStoryView {
  init(user: User) {
    self.picture = user.picture
    self.name = user.name
  }
}


#Preview {
  VStack(spacing: 32) {
    UserStoryView(
      picture: nil,
      name: "John Doe"
    )

    UserStoryView(
      picture: URL(string: "https://i.pravatar.cc/300?u=1"),
      name: "John Doe"
    )
  }
}
