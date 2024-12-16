//
//  MainView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI

struct MainView: View {
  //@State private var selectedTab = "Shows"
  
  var body: some View {
      VStack {
        TabView {
          
          ListShowsScreen()
            .tabItem { Image(systemName: "inset.filled.tv") }
          
          ListOfChannelsScreen()
            .tabItem { Image(systemName: "circle.grid.3x3") }
          
          AboutScreen()
            .tabItem { Image(systemName: "info.circle") }
          
        }
          .tabViewStyle(.sidebarAdaptable)
      }
   
    }
}

#Preview {
  MainView()
    .modelContainer(previewContainer)
    //.modelContainer(for: [Show.self, Channel.self], inMemory: true)
}
