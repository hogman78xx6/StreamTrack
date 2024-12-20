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
  
  @Binding var posterUrl: String?
  
  @State var urlString: String = ""
  
    var body: some View {
      VStack {
        if omdbViewModel.omdbModel.poster == "" {
          if let posterUrl {
            AsyncImage(url: URL(string: posterUrl)) { phase in
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
        } else {
          AsyncImage(url: URL(string: omdbViewModel.omdbModel.poster)) { phase in
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

      }

    }
}

//#Preview {
//    ShowLivePosterView()
//}
