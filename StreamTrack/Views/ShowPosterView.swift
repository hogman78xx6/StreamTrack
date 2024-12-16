//
//  ShowPosterView.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/13/24.
//

import SwiftUI

struct ShowPosterView: View {
  
  let url: URL
  
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
//  ShowPosterView(url: <#URL#>)
//}
