//
//  ChannelSelectionView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/5/24.
//

import SwiftUI
import SwiftData

struct ChannelSelectionView: View {
  
  @Query(sort: \Channel.name, order: .forward) private var channels: [Channel]
  
  @Environment(\.modelContext) private var context
  
  @Binding var selectedChannels: Set<Channel>
  
    var body: some View {
      VStack(alignment: .leading) {
        if channels.isEmpty {
          Text("No channels avaialble")
        } else {
          List(channels) { channel in
            HStack {
              Image(systemName: selectedChannels.contains(channel) ? "checkmark.square" : "square")
                .onTapGesture {
                  if !selectedChannels.contains(channel) {
                    selectedChannels.insert(channel)
                  } else {
                    selectedChannels.remove(channel)
                  }
                }
              Text(channel.name)
            }
          }
        }
      }
    }
}

//#Preview {
//    ChannelSelectionView()
//}
