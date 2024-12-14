//
//  AddChannelView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI

struct AddChannelView: View {
  
  @Environment(\.dismiss) var dismiss
  
  @Environment(\.modelContext) private var context
  
  @State private var channelName: String = ""
  
  @State private var channelType: ChannelType = .network
  
  private var isFormValid: Bool {
    !channelName.isEmptyOrWhitespace
  }
  
    var body: some View {
      NavigationStack {
        Form {
          TextField("Channel Name", text: $channelName)
          
          Picker("Channel Type", selection: $channelType) {
            ForEach(ChannelType.allCases) { channelType in
              Text(String(describing: channelType)).tag(channelType)
            }
          }
            
        }
        .navigationTitle("Add Channel")
        .toolbar {
          ToolbarItem {
            Button("Add") {
              let channel = Channel(name: channelName, channelType: channelType)
              context.insert(channel)
              
              do {
                  try context.save()
              } catch {
                  print(error.localizedDescription)
              }
              
              channelName = ""
              
              dismiss()
              
            }
            .disabled(!isFormValid)
          }
        }
        
      }
      
    
    }
}

#Preview {
    AddChannelView()
    .modelContainer(for: [Show.self, Channel.self], inMemory: true)
  
}
