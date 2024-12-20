//
//  ShowDetailView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/4/24.
//

import SwiftUI

struct ShowDetailView: View {
  
  @Environment(OMDBViewModel.self) private var omdbViewModel
  
  @State private var omdbModel: OMDBModel?
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
  
  var show: Show
  
  @State private var title: String = ""
  @State private var startDate: Date = Date()
  @State private var completed: Bool = false
  @State private var airDayOfWeek: DayOfWeek = .noSelection
  @State private var airTime: Date?
  @State private var endDate: Date?
  @State private var numberOfEpisodesWatched: Int?
  @State private var numberOfEpisodesAvailable: Int?
  @State private var showType: ShowType = .series
  @State private var selectedChannels: Set<Channel> = []
  @State private var notes: String = ""
  @State private var posterUrl: String?
  
  @State private var deleteAlert: Bool = false
  
  @State private var holdUrl: URL?
  
  @FocusState private var textFiledIsFocused: Bool
  
  
  private var isFormValid: Bool {
    !title.isEmptyOrWhitespace && !selectedChannels.isEmpty && !textFiledIsFocused
  }
  
  //@State private var posterURL: String = ""
  
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
      HStack {
        Button("Delete Show", role: .destructive) {
          deleteAlert = true
        }
        .buttonStyle(.borderedProminent)
        VStack {

          if posterUrl != nil && !posterUrl!.isEmpty {
            ShowLivePosterView(url: omdbViewModel.omdbModel.poster, posterUrl: posterUrl!)
              .frame(width: 100, height: 100)
          } else {
            Text("N/A")
              .frame(width: 100, height: 100)
          }
        }
        
      }
      
      HStack {
        Text("Show Title: ")
        TextField("Title", text: $title, axis: .vertical)
          .textFieldStyle(.roundedBorder)
          .textFieldStyle(.roundedBorder)
          .onMultilineSubmit(for: $title) {
            textFiledIsFocused = false
            guard !title.isEmptyOrWhitespace else { return }
            omdbViewModel.getRequest(title)
//            Task {
//              print("Getting title poster of \(title)")
//              await omdbViewModel.getRequest(title)
//            }
            posterUrl = omdbViewModel.omdbModel.poster
            print("Got URL in title submit: \(String(describing: posterUrl))")
            
          }
          .focused($textFiledIsFocused, equals: true)
      }
      DatePicker("Premiere Date", selection: $startDate, in: Date()..., displayedComponents: [.date])
      
      Picker("Show Type", selection: $showType) {
        ForEach(ShowType.allCases) { showType in
          Text(String(describing: showType)).tag(showType)
        }
      }
      
      Section("Toogle Switch to mark show as complete") {
        Toggle("Completed Show?", isOn: $completed)
      }
      
      Section("OPtional Fields") {
        Picker("New Show Premiere Day", selection: $airDayOfWeek) {
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
      airDayOfWeek = show.airDayOfWeek ?? .noSelection
      airTime = show.airTime
      endDate = show.endDate
      numberOfEpisodesWatched = show.numberOfEpisodesWatched
      numberOfEpisodesAvailable = show.numberOfEpisodesAvailable
      showType = show.showType
      if let notes = show.notes { self.notes = notes }
      selectedChannels = Set(show.channels)
      posterUrl = show.posterUrl
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save") {
          show.title = title
          show.startDate = startDate
          show.completed = completed
          show.showTypeId = showType.id
          show.notes = notes
          
          show.channels = Array(selectedChannels)
          
          show.airDayOfWeekId = airDayOfWeek.id
          
          // load the optionals if they are not nil
          if let airTime { show.airTime = airTime }
          if let endDate { show.endDate = endDate }
          if let numberOfEpisodesWatched { show.numberOfEpisodesWatched = numberOfEpisodesWatched }
          if let numberOfEpisodesAvailable { show.numberOfEpisodesAvailable = numberOfEpisodesAvailable }
          if notes != "" { show.notes = notes }
          
          //omdbModel = omdbViewModel.omdbModel
          if !omdbViewModel.validOMDB {
            show.posterUrl = ""
          } else if omdbViewModel.validOMDB && omdbViewModel.omdbModel.poster != "" {
            show.posterUrl = omdbViewModel.omdbModel.poster
            posterUrl = omdbViewModel.omdbModel.poster
            print("Poster URL: \(omdbViewModel.omdbModel.poster)")
            omdbViewModel.omdbModel = OMDBModel.defaultOMDB()
          }
          
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
  
  func fetchdataFromURL(urlString: String) async throws -> Data {
      guard let url = URL(string: urlString) else {
          throw URLError(.badURL)
      }
      
      let (data, response) = try await URLSession.shared.data(from: url)
      
      guard let httpResponse = response as? HTTPURLResponse,
            (200..<300).contains(httpResponse.statusCode) else {
          throw URLError(.badServerResponse)
      }
      
      return data
  }
  
}


//#Preview {
//    ShowDetailView()
//}
