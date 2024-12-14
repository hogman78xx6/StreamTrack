//
//  AddShowView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI
import SwiftData

struct AddShowView: View {
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
  
  @State private var title: String = ""
  @State private var startDate: Date = Date()
  @State private var airDayOfWeek: DayOfWeek?
  @State private var airTime: Date?
  @State private var endDate: Date?
  @State private var numberOfEpisodesWatched: Int?
  @State private var numberOfEpisodesAvailable: Int?
  @State private var showType: ShowType = .series
  @State private var selectedChannels: Set<Channel> = []
  
  @State private var notes: String?
  
  private var isFormValid: Bool {
    !title.isEmptyOrWhitespace && !selectedChannels.isEmpty
  }
  
  
  var body: some View {
    NavigationStack {
      Form {
        HStack {
          Text("Show Title: ")
          TextField("Title", text: $title, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .multilineSubmit(for: $title)
        
        }
        DatePicker("Start Date", selection: $startDate, in: Date()..., displayedComponents: [.date])
        
        Picker("Show Type", selection: $showType) {
          ForEach(ShowType.allCases) { showType in
            Text(String(describing: showType)).tag(showType)
          }
        }
        
        Section("OPtional Fields") {
          Picker("Air Day of Week", selection: $airDayOfWeek) {
            ForEach(DayOfWeek.allCases) { dayOfWeek in
              Text(String(describing: dayOfWeek)).tag(dayOfWeek)
            }
          }
          DatePicker("Air Time", selection: $airTime.bindUnwrap(defaultVal: Date()), displayedComponents: [.hourAndMinute])
          DatePicker("End Date", selection: $endDate.bindUnwrap(defaultVal: Date()), in: Date()..., displayedComponents: [.date])
          TextField("Number of Episodes Watched", value: $numberOfEpisodesWatched, format: .number)
          TextField("Number of Episodes Available", value: $numberOfEpisodesAvailable, format: .number)
        }
        
        Section("Select Channels") {
          ChannelSelectionView(selectedChannels: $selectedChannels)
        }
        
      }
      .navigationTitle("Add Show")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button("Save") {
            let show = Show(title: title, startDate: startDate, showType: showType)
            
            show.channels = Array(selectedChannels)
            
            // load the optionals if they are not nil
            if let airDayOfWeek { show.airDayOfWeekId = airDayOfWeek.id }
            if let airTime { show.airTime = airTime }
            if let endDate { show.endDate = endDate }
            if let numberOfEpisodesWatched { show.numberOfEpisodesWatched = numberOfEpisodesWatched }
            if let numberOfEpisodesAvailable { show.numberOfEpisodesAvailable = numberOfEpisodesAvailable }
            
            context.insert(show)
            
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
    }
    
  }
}

#Preview {
    AddShowView()
    .modelContainer(for: [Show.self, Channel.self], inMemory: true)
}
