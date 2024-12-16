//
//  ShowLivePosterView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/15/24.
//

import SwiftUI



struct ShowLivePosterView: View {
  
  @Binding var url: URL?
  
    var body: some View {
      AsyncImage(url: url) { phase in
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

//#Preview {
//    ShowLivePosterView()
//}
