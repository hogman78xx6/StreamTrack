//
//  AddShowView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI
import SwiftData

struct AddShowView: View {
  
  @Environment(OMDBViewModel.self) private var omdbViewModel
  
  @State private var omdbModel: OMDBModel?
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
  
  @State private var title: String = ""
  @State private var startDate: Date = Date()
  @State private var airDayOfWeek: DayOfWeek = .noSelection
  @State private var airTime: Date?
  @State private var endDate: Date?
  @State private var numberOfEpisodesWatched: Int?
  @State private var numberOfEpisodesAvailable: Int?
  @State private var showType: ShowType = .series
  @State private var selectedChannels: Set<Channel> = []
  
  @State private var notes: String = ""
  
  
  private var isFormValid: Bool {
    !title.isEmptyOrWhitespace && !selectedChannels.isEmpty
  }
  
  @State private var posterURL: String = ""
  
  
  
  var body: some View {
    NavigationStack {
      Form {
        HStack {
          Text("Show Title: ")
          TextField("Title", text: $title, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .onMultilineSubmit(for: $title) {
              guard !title.isEmptyOrWhitespace else { return }
              Task {
                print("Getting title poster of \(title)")
                await omdbViewModel.getRequest(title)
              }
            }
          
        }
        DatePicker("Premiere Date", selection: $startDate, displayedComponents: [.date])
        
        Picker("Show Type", selection: $showType) {
          ForEach(ShowType.allCases) { showType in
            Text(String(describing: showType)).tag(showType)
          }
        }
        .pickerStyle(.menu)
        
        Section("OPtional Fields") {
          Picker("New Show Premiere Day", selection: $airDayOfWeek) {
            ForEach(DayOfWeek.allCases) { dayOfWeek in
              Text(String(describing: dayOfWeek)).tag(dayOfWeek)
            }
          }
          .pickerStyle(.menu)
          
          DatePicker("Air Time", selection: $airTime.bindUnwrap(defaultVal: Date()), displayedComponents: [.hourAndMinute])
          DatePicker("End Date", selection: $endDate.bindUnwrap(defaultVal: Date()), in: Date()..., displayedComponents: [.date])
          TextField("Number of Episodes Watched", value: $numberOfEpisodesWatched, format: .number)
          TextField("Number of Episodes Available", value: $numberOfEpisodesAvailable, format: .number)
          TextField("Notes", text: $notes, axis: .vertical)
            .multilineTextAlignment(.leading)
            .multilineSubmit(for: $notes)
        }
        
        Section("Select Channels") {
          ChannelSelectionView(selectedChannels: $selectedChannels)
        }
        
      }
      .navigationTitle("Add Show")
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button("Cancel") { dismiss() }
            .buttonStyle(.bordered)
        }
        ToolbarItem(placement: .topBarTrailing) {
          Button("Save") {
            
            let show = Show(title: title, startDate: startDate, showType: showType)
            
            show.channels = Array(selectedChannels)
            
            show.airDayOfWeekId = airDayOfWeek.id
            
            // load the optionals if they are not nil
            if let airTime { show.airTime = airTime }
            if let endDate { show.endDate = endDate }
            if let numberOfEpisodesWatched { show.numberOfEpisodesWatched = numberOfEpisodesWatched }
            if let numberOfEpisodesAvailable { show.numberOfEpisodesAvailable = numberOfEpisodesAvailable }
            if notes != "" { show.notes = notes }
            
            // omdbModel = omdbViewModel.omdbModel
            //if let omdbModel {
            show.posterUrl = omdbViewModel.omdbModel.poster
              print("Poster URL: \(omdbViewModel.omdbModel.poster)")
            //}
            omdbViewModel.omdbModel = OMDBModel.defaultOMDB()
            
            
            context.insert(show)
            
            do {
              try context.save()
            } catch {
              print(error.localizedDescription)
            }
            
            dismiss()
          }
          .buttonStyle(.bordered)
          .disabled(!isFormValid)
        }
        
      }
      
    }
    
  }
}

//#Preview {
//  AddShowView(omdbViewModel: <#OMDBViewModel#>)
//    .modelContainer(for: [Show.self, Channel.self], inMemory: true)
//}
