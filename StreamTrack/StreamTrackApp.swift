//
//  StreamTrackApp.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI
import SwiftData

@main
struct StreamTrackApp: App {
  
  @State var omdbViewModel: OMDBViewModel = OMDBViewModel()
  
  var appContainer: ModelContainer
  
  init() {
    do {
      let storeURL = URL.documentsDirectory.appending(path: "database.sqlite")
      let schema = Schema([Show.self, Channel.self])
      let config = ModelConfiguration(schema: schema, url: storeURL)
      appContainer = try ModelContainer(for: schema, configurations: config)
    } catch {
      fatalError("Failed to configure SwiftData cintainer: \(error)")
    }
    
    do {
      var itemFetchDescriptor = FetchDescriptor<Channel>()
      itemFetchDescriptor.fetchLimit = 1
      guard try appContainer.mainContext.fetch(itemFetchDescriptor).count == 0 else { return }
      
      let channels = [
        Channel(name: "Hulu", channelType: .streaming),
        Channel(name: "Netflix", channelType: .streaming),
        Channel(name: "Amazon Prime", channelType: .streaming),
        Channel(name: "Disney+", channelType: .streaming),
        Channel(name: "Apple TV+", channelType: .streaming),
        Channel(name: "Paramount+", channelType: .streaming),
      ]
      
      for channel in channels{
        appContainer.mainContext.insert(channel)
      }
      
      do {
        try appContainer.mainContext.save()
      } catch {
        print(error.localizedDescription)
      }
      
    } catch {
      fatalError("Failed to load container")
    }
  }
      
 
  
    var body: some Scene {
        WindowGroup {
            MainView()
            .environment(omdbViewModel)
            .environment(\.colorScheme, .dark)
        }
        .modelContainer(appContainer)
        
        
    }
}
