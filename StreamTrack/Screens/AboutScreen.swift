//
//  AboutScreen.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/10/24.
//

import SwiftUI

struct AboutScreen: View {
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading) {
  //        Text("Welcome to StreamTrack!")
  //          .font(.title).bold()
          
          Text("This app allows you to keep track of all your TV watching activity.  It's designed for those of us who get their contetent from streaming services along with network TV channels.")
            .padding([.top, .bottom])
          
          Text("Add the shows and movies you want to watch in the Shows Tab.")
            .padding([.top, .bottom])
          
          Text("Don't see the channel you ned in the deafulat list?  You can add your favorite streaming services and televiosn channels in addition to the ones added by default in the chennels tab.")
            .padding([.top, .bottom])
          
          Text("You can inlude sevral pieces of information about the shows amd movies you are adding.")
            .padding([.top, .bottom])
          
          Text("You must select at least one channel to save a new show or movie.")
            .padding([.top, .bottom])
          
          Text("Click on the Filter button in the Shows tab to filter shows by their title or by channel they are on.")
            .padding([.top, .bottom])
          
          Text("Enjoy!")
            .font(.headline).bold()
            //.padding([.top, .bottom])
          
          Text("StreamTrack is currently in beta.  Please let me know if you have any suggestions or if you have any issues.")
            .padding(.bottom)
          
          Text("mmknych@yahoo.com")
          Text ("Copyright © 2024 Michael Knych")
          Text ("All rights reserved")
          
          Text("Release: \(UIApplication.release)")
            
        }
        .font(.headline)
        .padding()
        Spacer()
      }
      .toolbarColorScheme(.dark, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarBackground(.navBar, for: .navigationBar)
      .toolbarBackground(.visible, for: .tabBar)
      .toolbarBackground(.navBar, for: .tabBar)
      .navigationTitle(Text("Welcome to StreamTrack!"))
      .navigationBarTitleDisplayMode(.inline)
    }
    
    
    
    
  }
}

#Preview {
  AboutScreen()
}
