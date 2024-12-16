//
//  Show.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import Foundation
import SwiftData

@Model
class Show {
  @Attribute(.unique) var title: String
  var startDate: Date
  var completed: Bool
  var airDayOfWeekId: Int?
  var airTime: Date?
  var endDate: Date?
  var numberOfEpisodesWatched: Int?
  var numberOfEpisodesAvailable: Int?
  var showTypeId: Int
  @Relationship(deleteRule: .nullify, inverse: \Channel.shows)
  var channels: [Channel] = [Channel]()
  var notes: String?
  var posterUrl: String?
  
  var showType: ShowType {
    ShowType(rawValue: showTypeId)!
  }
  
  var airDayOfWeek: DayOfWeek? {
    if let airDayOfWeekId {
      return DayOfWeek(rawValue: airDayOfWeekId)!
    } else {
      return nil
    }
  }
  
  init(title: String, startDate: Date, completed: Bool = false, airTime: Date? = nil, airDayOfWeek: DayOfWeek? = nil, endDate: Date? = nil, numberOfEpisodesWatched: Int? = nil, numberOfEpisodesAvailable: Int? = nil, showType: ShowType, notes: String? = nil ) {
    self.title = title
    self.startDate = startDate
    self.completed = completed
    self.airDayOfWeekId = airDayOfWeek?.id
    self.airTime = airTime
    self.endDate = endDate
    self.numberOfEpisodesWatched = numberOfEpisodesWatched
    self.numberOfEpisodesAvailable = numberOfEpisodesAvailable
    self.showTypeId = showType.id
    self.notes = notes
  }
}
