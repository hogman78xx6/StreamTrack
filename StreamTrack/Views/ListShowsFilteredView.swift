//
//  ShowsFilteredListView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/9/24.
//

import SwiftUI
import SwiftData

struct ListShowsFilteredView: View {
  
  @Environment(\.modelContext) private var context
  
  @Query(sort: [SortDescriptor(\Show.completed, order: .forward), SortDescriptor(\Show.title, order: .forward)]) var shows: [Show]
  
  @Query(sort: \Channel.name, order: .forward) var channels: [Channel]
  
  let filterOption: FilterOption
  
  init(filterOption: FilterOption = .none) {
    self.filterOption = filterOption
    print("filterOption: \(filterOption)")
    switch self.filterOption {
    case .title(let showTitle):
      _shows = Query(filter: #Predicate {
        $0.title.contains(showTitle)
      })
    case .name(let channelName):
      // this knows to query on Channels
      _channels = Query(filter: #Predicate { $0.name == channelName })
    case .none:
      _shows = Query(sort: [SortDescriptor(\Show.completed, order: .forward), SortDescriptor(\Show.title, order: .forward)])
    }
  }
  
  var body: some View {
    VStack {
      
        switch filterOption {
        case .title(let showTitle):
          if shows.isEmpty {
            ContentUnavailableView {
              Text("No Shows matching")
            }
            .background(Color.showBackground)
          } else {
            let header = String("Shows matching title : \(showTitle)")
            ListShowQueryResultsView(shows: shows, header: header)
          }
        case .name:
          let shows = channels.first?.shows ?? []
            if shows.isEmpty {
              ContentUnavailableView {
                Text("No Shows matching : \(channels.first?.name ?? "")")
              }
              .background(Color.showBackground)
            } else {
              let header = String("Shows on \(channels.first?.name ?? "")")
              ListShowQueryResultsView(shows: shows, header: header)
            }
          
        case .none:
          if shows.isEmpty {
            ContentUnavailableView {
              Text("No Shows yet")
            }
            .background(Color.showBackground)
          } else {
            ListShowQueryResultsView(shows: shows, header: String("All Shows"))
          }
        }
        
     

        
   
    }  // VStack
  }
}

#Preview {
  ListShowsFilteredView()
}
