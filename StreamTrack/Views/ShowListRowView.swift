//
//  ShowListRowView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/8/24.
//

import SwiftUI
import SwiftData

struct ShowListRowView: View {
  
  let show: Show
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
  }()   // ()) means run the closdure and give a value to dateFormatter
  
  
  func getChannelList (show: Show) -> String {
    let channelList = show.channels?.map(\Channel.name) ?? []
    return channelList.joined(separator: ", ")
  }
  
    var body: some View {
      HStack {
        if show.completed {
          Image(systemName: "checkmark.circle.fill")
            .resizable()
            .foregroundColor(.green)
            .frame(width: 20, height: 20)
        } else {
          Image(systemName: "circle")
            .resizable()
            .foregroundColor(.clear)
            .frame(width: 20, height: 20)
        }
        VStack(alignment: .leading) {
          HStack {
            Text(show.title)
            Spacer()
          }  // HStack
          Text(show.showType.description)
          HStack {
            VStack(alignment: .leading) {
              if getChannelList(show: show).count > 1 {
                Text("Channels: ")
              } else {
                Text("Channel: ")
              }
              Text(getChannelList(show: show))
            }
          }  // HStack
          HStack {
            Text("Start Date: ")
            Text(dateFormatter.string(from: show.startDate))
            Spacer()
          }
          
        }
      }
    }
}

//#Preview {
//    ShowListRowView()
//}
