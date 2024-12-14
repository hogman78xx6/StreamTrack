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
          
          ListOfShowsView()
            .tabItem { Image(systemName: "inset.filled.tv") }
          
          ListOfChannelsView()
            .tabItem { Image(systemName: "circle.grid.3x3") }
          
        }
      }
  }
}

#Preview {
  MainView()
    .modelContainer(previewContainer)
    //.modelContainer(for: [Show.self, Channel.self], inMemory: true)
}
