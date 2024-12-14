//
//  ListOfShowsView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI
import SwiftData

struct ListOfShowsView: View {
  
  @Query(sort: [SortDescriptor(\Show.completed, order: .forward), SortDescriptor(\Show.title, order: .forward)]) var shows: [Show]
  
  @Environment(\.modelContext) private var context
  
  @State var showAddShow: Bool = false
  
  func formattedDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle =  .short
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }
  
  
  func getChannelList (show: Show) -> String {
    let channelList = show.channels?.map(\Channel.name) ?? []
    return channelList.joined(separator: ", ")
  }
  
  private func deleteShow(indexSet: IndexSet) {
    
    indexSet.forEach { index in
      let show = shows[index]
      context.delete(show)
      print("got to here")
      do {
        try context.save()
      } catch {
        print(error.localizedDescription)
      }
    }
    
  }
  
  var body: some View {
    NavigationStack {
      VStack {
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
            //.onDelete(perform: deleteShow)
            
          }
          
        }
      }
       
    .navigationDestination(for: Show.self) { show in
      ShowDetailView(show: show)
    }
      .navigationTitle("Shows")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add Show") {
            showAddShow = true
          }
        }
      }
      .sheet(isPresented: $showAddShow) { AddShowView() }
      
    }
  }
}

#Preview {
  ListOfShowsView()
    .modelContainer(for: [Show.self, Channel.self], inMemory: true)
}
