//
//  ShowDetailView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/4/24.
//

import SwiftUI

struct ShowDetailView: View {
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
  
  var show: Show
  
  @State private var title: String = ""
  @State private var startDate: Date = Date()
  @State private var completed: Bool = false
  @State private var airDayOfWeek: DayOfWeek?
  @State private var airTime: Date?
  @State private var endDate: Date?
  @State private var numberOfEpisodesWatched: Int?
  @State private var numberOfEpisodesAvailable: Int?
  @State private var showType: ShowType = .series
  @State private var selectedChannels: Set<Channel> = []
  @State private var notes: String?
  
  @State private var deleteAlert: Bool = false
  
  private var isFormValid: Bool {
    !title.isEmptyOrWhitespace && !selectedChannels.isEmpty
  }
  
  private func deleteShow(_ show: Show) {
      context.delete(show)
  
      do {
        try context.save()
        dismiss()
      } catch {
        print(error.localizedDescription)
      }
  
  }
  
  var body: some View {
    
    Form {
      Button("Delete Show", role: .destructive) {
        deleteAlert = true
      }
      .buttonStyle(.borderedProminent)
      
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
      
      Section("Toogle Switch to mark show as complete") {
        Toggle("Completed Show?", isOn: $completed)
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
    .navigationTitle(title)
    .onAppear {
      title = show.title
      startDate = show.startDate
      completed = show.completed
      airDayOfWeek = show.airDayOfWeek
      airTime = show.airTime
      endDate = show.endDate
      numberOfEpisodesWatched = show.numberOfEpisodesWatched
      numberOfEpisodesAvailable = show.numberOfEpisodesAvailable
      showType = show.showType
      notes = show.notes
      if let channels = show.channels {
        selectedChannels = Set(channels)
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save") {
          let show = Show(title: title, startDate: startDate, completed: completed, showType: showType)
          
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
    .confirmationDialog("Delete Show", isPresented: $deleteAlert) {
      Button("Delete Show") { deleteShow(show) }
      .foregroundColor(.red)
    } message: {
      Text("Are you sure you want to delete \(show.title)?")
        .font(.largeTitle)
    }
    
  }
}

//#Preview {
//    ShowDetailView()
//}
