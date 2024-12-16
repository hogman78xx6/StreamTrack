//
//  Channel.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import Foundation
import SwiftData

@Model
class Channel {
  @Attribute(.unique) var name: String
  var channelTypeId: Int
  //@Relationship(deleteRule: .noAction, inverse: \Show.channels)
  var shows: [Show]? = [Show]()
  
  var channelType: ChannelType {
    ChannelType(rawValue: channelTypeId)!
  }
  
  init(name: String, channelType: ChannelType) {
    self.name = name
    self.channelTypeId = channelType.id
  }
}

