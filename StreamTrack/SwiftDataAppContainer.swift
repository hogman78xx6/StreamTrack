//
//  SwiftDataAppContainer.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/6/24.
//

import Foundation
import SwiftData

@MainActor
var appContainer: ModelContainer = {
  do {
    let container = try ModelContainer(
      
      for: Show.self, Channel.self
      
    )
    
    var itemFetchDescriptor = FetchDescriptor<Channel>()
    itemFetchDescriptor.fetchLimit = 1
    
    guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else { return container }
    
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
