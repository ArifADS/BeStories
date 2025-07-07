//
//  BeStoriesApp.swift
//  BeStories
//
//  Created by Arif De Sousa on 7/7/25.
//

import SwiftUI
import SwiftData

@main
struct BeStoriesApp: App {
  let service = StoriesService(persistence: .init())


  var body: some Scene {
    WindowGroup {
      ContentView(
        service: service
      )
    }
  }
}
