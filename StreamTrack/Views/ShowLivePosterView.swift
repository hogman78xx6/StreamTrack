//
//  ShowLivePosterView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/15/24.
//

import SwiftUI



struct ShowLivePosterView: View {
  
  @Environment(OMDBViewModel.self) private var omdbViewModel
  
  var url: String
  
  let posterUrl: String
  
  @State var urlString: String = ""
  
    var body: some View {
      VStack {
        
          AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
              image
                .resizable()
                .scaledToFit()
            } else if phase.error != nil {
              Text("Error loading image")
            } else {
              Color.gray
            }
          }
         
        
      }
      .onAppear {
        if omdbViewModel.omdbModel.poster == "" {
          print("======>>>  posterUrl: \(posterUrl)")
          urlString = posterUrl
        } else {
          print("======>>>  omdbViewModel.omdbModel.poster: \(omdbViewModel.omdbModel.poster)")
          urlString = omdbViewModel.omdbModel.poster
          
        }
      }
      
      
    }
}

//#Preview {
//    ShowLivePosterView()
//}
