//
//  ChannelDetailView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/4/24.
//

import SwiftUI

struct ChannelDetailView: View {
  
  @Environment(\.dismiss) var dismiss
  
  @Environment(\.modelContext) private var context
  
  var channel: Channel
  
  @State var channelName: String = ""
  @State var channelType: ChannelType = .streaming
  
  @State private var deleteError: Bool = false
  @State private var goodDelete: Bool = false
  
  private var isFormValid: Bool {
    !channelName.isEmptyOrWhitespace
  }
  
  private func delete(_ channel: Channel, deleteError: Binding<Bool>) -> Bool {
    
    print("go tot here")
    
    print ("Shows: \(channel.shows?.count ?? 0)")
    let showsCount = channel.shows?.count ?? 0
    if showsCount == 0 {
        print("got to delete channel")
        context.delete(channel)
        do {
          try context.save()
          print("save successful")
        } catch {
          print(error.localizedDescription)
        }
      return false
      } else {
      return true
    }
  
  }
  
  var body: some View {
    
    VStack {
      Form {
        TextField("Channel Name", text: $channelName)
          .textFieldStyle(.roundedBorder)
        
        Picker("Channel Type", selection: $channelType) {
          ForEach(ChannelType.allCases) { channelType in
            Text(String(describing: channelType)).tag(channelType)
          }
        }
        
        Section("List of Shows for This Channel") {
          if let shows = channel.shows {
            List(shows) { show in
              Text(show.title)
            }
          }
          
        }
        
      }
    }
    .onAppear {
      channelName = channel.name
      channelType = channel.channelType
    }
    .navigationTitle(channel.name)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem {
        Button("Delete", role: .destructive) {
          deleteError = delete(channel, deleteError: $deleteError)
          if !deleteError {
            goodDelete = true
            //dismiss()
          }
          
        }
      }
      ToolbarItem {
        Button("Update") {
          
          channel.name = channelName
          channel.channelTypeId = channelType.id
          
          do {
            try context.save()
          } catch {
            print(error.localizedDescription)
          }
          
          dismiss()
          
          
        }
        .disabled(!isFormValid)
      }
      
        
      }
    .alert("Could not delete: \(channel.name)", isPresented: $deleteError) {
      Button("Got it!!", role: .cancel) { dismiss() }
    } message: {
      Text("Could not delete \(channel.name) because it has shows.")
    }
    .alert("Deletion Successful for: \(channel.name)", isPresented: $goodDelete) {
      Button("Got it!!", role: .cancel) { dismiss() }
    } message: {
      Text("\(channel.name) was successfully deleted.")
    }

  }
  
  
  
}



//#Preview {
//  ChannelDetailView(channel: <#Channel#>)
//}
