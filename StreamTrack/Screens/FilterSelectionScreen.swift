//
//  FilterSelectionScreen.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/9/24.
//

import SwiftUI
import SwiftData

enum FilterOption {
  case title(String)
  case name(String)
//  case completedShow(Bool)
//  case notCompletedShow(Bool)
  case none
}

struct FilterSelectionScreen: View {
  
  @Environment(\.dismiss) private var dismiss
  
  @Binding var filterSelectionConfig: FilterSelectionConfig
  
  //@State private var selectedChannels: Set<Channel> = []
  
  @Query(sort: \Channel.name, order: .forward) private var channels: [Channel]
  
  @State private var selectedChannel: String = ""
  
    var body: some View {
       Form {
         Section("Filter by Title") {
           TextField("Title", text: $filterSelectionConfig.showTitle)
           Button("Apply") {
             filterSelectionConfig.filter = .title(filterSelectionConfig.showTitle)
             dismiss()
           }
         }
         Section("List shows by selected channel") {
           Picker("Channel", selection: $selectedChannel) {
             ForEach(channels, id: \.name) {
               Text($0.name).tag($0.name)
             }
           }
           .pickerStyle(.wheel)
           
           Button("Apply") {
             if selectedChannel == "" {
               selectedChannel = channels.first?.name ?? ""
             }
             print("Selected Channel: \(selectedChannel)")
             filterSelectionConfig.channelName = selectedChannel
             filterSelectionConfig.filter = .name(filterSelectionConfig.channelName)
             dismiss()
           }
         }
      }
    }
}

#Preview {
  FilterSelectionScreen(filterSelectionConfig: .constant(FilterSelectionConfig(filter: .title("Batman"))))
}
