//
//  ShowType.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import Foundation

enum ShowType: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
  
  case series = 0
  case movie
  
  var id: Int { rawValue }  // needn this to conform to Idnetifiable in the enum
  
  var description: String {
    switch self {
    case .series: return "Series"
    case .movie: return "Movie"
    }
  }
}
