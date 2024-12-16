//
//  ListShowQueryResultsView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/11/24.
//

import SwiftUI

struct ListShowQueryResultsView: View {
  
  let shows: [Show]
  
  let header: String
  
    var body: some View {
      List {
        Section(header: Text(header)) {
          ForEach(shows) { show in
            NavigationLink(value: show) {
              ShowListRowView(show: show)
            }
            //.listRowInsets(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
          }
          .listRowBackground(Color.primary.opacity(0.1))
        }
        .font(.headline)
        .textCase(nil)
      }
      
      .scrollContentBackground(.hidden)
      .background(Color.showBackground)
      .navigationDestination(for: Show.self) { show in
        ShowDetailView(show: show)
      }
    }
}

//#Preview {
//    ListShowQueryResultsView()
//}
