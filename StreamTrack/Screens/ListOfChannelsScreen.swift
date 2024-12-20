//
//  ListOfChannelsScreen.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI
import SwiftData

struct ListOfChannelsScreen: View {
  
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
        ZStack {
          Color.channelBackground
            .ignoresSafeArea()
          VStack {
            VStack {
              Text("Channels")
                .foregroundStyle(Color.white)
                .font(.largeTitle)
                .fontWeight(.bold)
              
            }
            .padding(6)
            .frame(maxWidth: .infinity)
            .background(Color.navBar)
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
                .listRowBackground(Color.primary.opacity(0.1))
                // .onDelete(perform: deleteChannel)
                
              }
              .scrollContentBackground(.hidden)
              //.background(Color.channelBackground)
              .navigationDestination(for: Channel.self) { channel in
                ChannelDetailView(channel: channel)
              }
            }
          }
      }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.navBar, for: .navigationBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.navBar, for: .tabBar)
        //.navigationTitle("Channels")
        
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button("Add Channel") {
              showAddChannel = true
            }
            .buttonStyle(.bordered)
          }
          
        }
        .sheet(isPresented: $showAddChannel) {
          AddChannelView()
        }
        
    
      
      
      
      
   } //
  }
}

#Preview {
  ListOfChannelsScreen()
    .modelContainer(for: [Show.self, Channel.self], inMemory: true)
}
