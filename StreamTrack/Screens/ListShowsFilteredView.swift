//
//  ShowsFilteredListView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/9/24.
//

import SwiftUI
import SwiftData

struct ListShowsFilteredView: View {
  
  @Query(sort: [SortDescriptor(\Show.completed, order: .forward), SortDescriptor(\Show.title, order: .forward)]) var shows: [Show]
  
  let filterOption: FilterOption
  
  init(filterOption: FilterOption = .none) {
    self.filterOption = filterOption
    switch self.filterOption {
    case .title(let showTitle):
      _shows = Query(filter: #Predicate {
        $0.title.contains(showTitle)
      })
    case .none:
      _shows = Query()
    }
  }
  
    var body: some View {
      //VStack {
        if shows.isEmpty {
          ContentUnavailableView {
            Text("No Shows yet")
          }
        } else {
          List {
            ForEach(shows) { show in
              NavigationLink(value: show) {
                ShowListRowView(show: show)
              }
            }
            
          }
          
        }
      //}  // VStack
    }
}

#Preview {
    ListShowsFilteredView()
}
