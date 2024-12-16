//
//  ListShowsScreen.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI
import SwiftData

struct FilterSelectionConfig {
  var showTitle: String = ""
  var channelName: String = ""
  var completedShows: Bool = false
  var notCompletedShows: Bool = false
  var filter: FilterOption = .none
}

struct ListShowsScreen: View {
  
  @State private var showAddShow: Bool = false
  @State private var showFilterOptions = false
  
  @State private var filterSelectionConfig: FilterSelectionConfig = FilterSelectionConfig()
  
  var body: some View {
    NavigationStack {
      
        VStack {

          ListShowsFilteredView(filterOption: filterSelectionConfig.filter)
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.navBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.navBar, for: .tabBar)
        .navigationTitle("StreamTrack Shows")
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button("Filter") {
              showFilterOptions = true
            }
            .buttonStyle(.bordered)
          }
          ToolbarItem(placement: .topBarLeading) {
              Button("Clear Filters") {
                filterSelectionConfig = FilterSelectionConfig()
              }
              .buttonStyle(.bordered)
            }
          
          ToolbarItem(placement: .topBarTrailing) {
            Button("Add Show") {
              showAddShow = true
            }
            .buttonStyle(.bordered)
          }
        }
        .sheet(isPresented: $showAddShow) { AddShowView() }
        .sheet(isPresented: $showFilterOptions) { FilterSelectionScreen(filterSelectionConfig: $filterSelectionConfig)
        }
  
      
    } //  NavigationStack
  }
}

#Preview {
  ListShowsScreen()
    .modelContainer(for: [Show.self, Channel.self], inMemory: true)
}
