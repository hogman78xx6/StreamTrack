//
//  ChannelType.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/4/24.
//

import Foundation

enum ChannelType: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
  
  case network = 0
  case streaming
  
  var id: Int { rawValue }  // needn this to conform to Idnetifiable in the enum
  
  var description: String {
    switch self {
    case .network: return "Network"
    case .streaming: return "Streaming Service"
    }
  }
}
