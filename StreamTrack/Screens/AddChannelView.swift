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
  
  @FocusState private var textFieldIsFocused: Bool
  
  private var isFormValid: Bool {
    !channelName.isEmptyOrWhitespace && !textFieldIsFocused
  }
  
    var body: some View {
      NavigationStack {
        Form {
          TextField("Channel Name", text: $channelName)
            .textFieldStyle(.roundedBorder)
            .focused($textFieldIsFocused)
          
          Picker("Channel Type", selection: $channelType) {
            ForEach(ChannelType.allCases) { channelType in
              Text(String(describing: channelType)).tag(channelType)
            }
          }
          .pickerStyle(.menu)
        }
        .navigationTitle("Add Channel")
        .toolbar {
          ToolbarItem {
            Button("Cancel") { dismiss() }
              .buttonStyle(.bordered)
          }
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
            .buttonStyle(.bordered)
            .disabled(!isFormValid)
          }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.navBar, for: .navigationBar)
        //.environment(\.colorScheme, .dark)
      } //
      
      
    
    }
}

#Preview {
    AddChannelView()
    .modelContainer(for: [Show.self, Channel.self], inMemory: true)
  
}
