//
//  AddShowView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/3/24.
//

import SwiftUI
import SwiftData

struct AddShowView: View {
  
  enum Field: Hashable {
    case none
    case title
    case numberOfEpisodesWatched
    case numberOfEpisodesAvailable
    case notes
  }
  
  @Environment(OMDBViewModel.self) private var omdbViewModel
  
  @State private var omdbModel: OMDBModel?
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
  
  @State private var title: String = ""
  @State private var startDate: Date = Date()
  @State private var airDayOfWeek: DayOfWeek = .noSelection
  @State private var airTime: Date?
  @State private var endDate: Date?
  @State private var numberOfEpisodesWatched: Int = 0
  @State private var numberOfEpisodesAvailable: Int = 0
  @State private var showType: ShowType = .series
  @State private var selectedChannels: Set<Channel> = []
  
  @State private var notes: String = ""
  
  @FocusState private var textFieldIsFocused: Field?
  
  //@State private var showTitleSubmitted: Bool = false
  
  
  private var isFormValid: Bool {
    !title.isEmptyOrWhitespace && !selectedChannels.isEmpty && textFieldIsFocused != .title
  }
  
  @State private var posterURL: String = ""
  
  
  
  var body: some View {
    NavigationStack {
      Form {
        HStack {
          Text("Show Title: ")
          TextField("Title", text: $title, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .onMultilineSubmit(for: $title, submitLabel: .continue) {
              guard !title.isEmptyOrWhitespace else { return }
              omdbViewModel.getRequest(title)
            }
            .focused($textFieldIsFocused, equals: .title)
          
        }
        VStack {
          DatePicker("Premiere Date", selection: $startDate, displayedComponents: [.date])
            .datePickerStyle(.compact)
          
          Picker("Show Type", selection: $showType) {
            ForEach(ShowType.allCases) { showType in
              Text(String(describing: showType)).tag(showType)
            }
          }
          .pickerStyle(.menu)
        }
        
        if textFieldIsFocused != .title {
          Section("OPtional Fields") {
            
              Picker("New Show Premiere Day", selection: $airDayOfWeek) {
                ForEach(DayOfWeek.allCases) { dayOfWeek in
                  Text(String(describing: dayOfWeek)).tag(dayOfWeek)
                }
              }
              .pickerStyle(.menu)
              
              DatePicker("Air Time", selection: $airTime.bindUnwrap(defaultVal: Date()), displayedComponents: [.hourAndMinute])
              DatePicker("End Date", selection: $endDate.bindUnwrap(defaultVal: Date()), in: Date()..., displayedComponents: [.date])
              Picker("Number of Episodes Watched", selection: $numberOfEpisodesWatched) {
                ForEach(0...50, id: \.self) { value in
                  Text(String(value)).tag(String(value))
                }
              }
              .pickerStyle(.menu)
            
            Picker("Number of Episodes Available", selection: $numberOfEpisodesAvailable) {
              ForEach(0...50, id: \.self) { value in
                Text(String(value)).tag(String(value))
              }
            }
            .pickerStyle(.menu)
              
              TextField("Notes", text: $notes, axis: .vertical)
                .multilineTextAlignment(.leading)
                .multilineSubmit(for: $notes, submitLabel: .return)
                .focused($textFieldIsFocused, equals: .notes)
            
          }
          
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
            if numberOfEpisodesWatched > 0 { show.numberOfEpisodesWatched = numberOfEpisodesWatched }
            if numberOfEpisodesAvailable > 0 { show.numberOfEpisodesAvailable = numberOfEpisodesAvailable }
            if notes != "" { show.notes = notes }
            
            
            // omdbModel = omdbViewModel.omdbModel
            //if let omdbModel {
            show.posterUrl = omdbViewModel.omdbModel.poster
            print("ViewModel Poster: \(omdbViewModel.omdbModel.poster)")
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
      // forces the TextFiled for the showe title to be foucsed and the keyboard opened
      .onAppear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ textFieldIsFocused = .title }

      }
      .toolbarColorScheme(.dark, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarBackground(.navBar, for: .navigationBar)
      //.environment(\.colorScheme, .dark)
      
    } //
    
  }
}

//#Preview {
//  AddShowView(omdbViewModel: <#OMDBViewModel#>)
//    .modelContainer(for: [Show.self, Channel.self], inMemory: true)
//}
