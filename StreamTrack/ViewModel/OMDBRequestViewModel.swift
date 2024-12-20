//
//  OMDBRequestViewModel.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/19/24.
//

import Foundation


@Observable
class OMDBViewModelNew {
  
  var omdbModel: OMDBModel = OMDBModel.defaultOMDB()
  var validOMDB: Bool = false
  
  
  func getRequest(_ title: String) {
    let urlString = String("https://www.omdbapi.com/?t=\(title)&apikey=a502de93")
    getResult(urlString: urlString)
    print("Return from getRequest")
  }
  
  func getResult(urlString: String) {
    // Try to get url
    guard let url = URL(string: urlString) else { return }
    
    // Send get request from quote API
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // Try to get data and any error information
    let task = URLSession.shared.dataTask(with: request)
    {
      (data, response, error) in
      let jsonDecoder = JSONDecoder()
      // This is called only if error is not nil
      if let error = error {
        print(error)
        return
      }
      
      // Get data if it is not nil
      guard let data = data else {
        print("data was nil")
        return
      }
      
      do {
        let newOMDBModel = try jsonDecoder
          .decode(OMDBModel.self, from: data)
        
        // Crucial step - update quoteModel
        DispatchQueue.main.async {
          self.omdbModel = newOMDBModel
          self.validOMDB = true
          print ("OMDB model updated")
        }
        
      } catch {
        self.validOMDB = false
        print(error)
      }
      
    }
    task.resume()
  }
}

