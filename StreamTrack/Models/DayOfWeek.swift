//
//  DayOfWeek.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/6/24.
//

import Foundation

enum DayOfWeek: Int, Codable, CaseIterable, Identifiable, CustomStringConvertible {
  case noSelection = 0
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  case sunday
  
  var id: Int { rawValue }
  
  public var description: String {
    switch self {
    case .noSelection: return "No Selection"
    case .monday: return "Monday"
    case .tuesday: return "Tuesday"
    case .wednesday: return "Wednesday"
    case .thursday: return "Thursday"
    case .friday: return "Friday"
    case .saturday: return "Saturday"
    case .sunday: return "Sunday"
    }
  }
}
