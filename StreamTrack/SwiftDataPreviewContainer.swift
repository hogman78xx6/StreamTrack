//
//  SwiftDataPreviewContainer.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/6/24.
//

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
  do {
    let container = try ModelContainer(
      
      for: Show.self, Channel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)
      
    )
    
    let channels = [
      Channel(name: "Hulu", channelType: .streaming),
      Channel(name: "Netflix", channelType: .streaming),
      Channel(name: "Amazon Prime", channelType: .streaming),
      Channel(name: "Disney+", channelType: .streaming),
      Channel(name: "Apple TV+", channelType: .streaming),
      Channel(name: "Paramount+", channelType: .streaming),
    ]
    
    for channel in channels{
      container.mainContext.insert(channel)
    }
    
    return container
  } catch {
    fatalError("Failed to create container")
  }
}()
