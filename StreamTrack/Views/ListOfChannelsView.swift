//
//  ListOfChannelsView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI
import SwiftData

struct ListOfChannelsView: View {
  
  @Query(sort: \Channel.name, order: .forward) var channels: [Channel]
  
  @Environment(\.modelContext) private var context
  
  @State private var showAddChannel: Bool = false
  
//  private func deleteChannel(at indexSet: IndexSet) {
//    
//    for index in indexSet {
//      
//      let channel = channels[index]
//      
//      if let shows = channel.shows {
//        print("go tot here")
//        if shows.isEmpty {
//          print("got to delete shows")
//          context.delete(channel)
//          do {
//            try context.save()
//          } catch {
//            print(error.localizedDescription)
//          }
//        }
//      } else {
//        print("hit return")
//        return
//      } // end of if-let
//      
//    }  // end of for index
//    
//  }
  
  var body: some View {
    NavigationStack {
      VStack {
        if channels.isEmpty {
          ContentUnavailableView {
            Text("No channels yet")
          }
        } else {
          List {
            ForEach(channels) { channel in
              NavigationLink(value: channel) {
                HStack {
                  Text(channel.name)
                  Spacer()
                  Text(channel.channelType.description)
                }
                
              }
            }
            // .onDelete(perform: deleteChannel)
            
          }
          .navigationDestination(for: Channel.self) { channel in
            ChannelDetailView(channel: channel)
          }
        }
      }
      
      .navigationTitle("Channels")
      
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add Channel") {
            showAddChannel = true
          }
        }
      }
      .sheet(isPresented: $showAddChannel) {
        AddChannelView()
          .presentationDetents([.fraction(0.50)])
      }
      
    }
  }
}

#Preview {
  ListOfChannelsView()
    .modelContainer(for: [Show.self, Channel.self], inMemory: true)
}
