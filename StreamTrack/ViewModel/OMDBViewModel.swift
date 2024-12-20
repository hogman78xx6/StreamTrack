//
//  OMDBViewModel.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/11/24.
//

import Foundation
import Observation

//@MainActor
@Observable
class OMDBViewModel {
  var omdbModel: OMDBModel = OMDBModel.defaultOMDB()
  var validOMDB: Bool = false
  
//  func getRequest(_ title: String) async {
//    let urlString = String("https://www.omdbapi.com/?t=\(title)&apikey=a502de93")
//    guard let downloadedResult: OMDBModel = await WebService().downloadData(fromURL: urlString) else {
//      validOMDB = false
//      print("+++  Bad request results +++")
//      return
//    }
//    omdbModel = downloadedResult
//    validOMDB = true
//    print("========> Good Request Results. Poster: \(downloadedResult.poster)")
//  }
  
  func getRequest(_ title: String) async {
    let fetchTask = Task {
      print("Attempting URL Request for: \(title)")
      let urlString = String("https://www.omdbapi.com/?t=\(title)&apikey=a502de93")
      let url = URL(string: urlString)!
      let (data, _) = try await URLSession.shared.data(from: url)
      try Task.checkCancellation()
      let decodedResponse = try? JSONDecoder().decode(OMDBModel.self, from: data)
      print("+++++++++> Good Request Results. Poster: \(String(describing: decodedResponse?.poster))")
      return decodedResponse
      
    }
      
    do {
      let omdbModel = try await fetchTask.value
      if let omdbModel {
        self.omdbModel = omdbModel
        validOMDB = true
        print("!!!!  WE GOT GOOD POSTER DATA  !!!!")
      } else {
        validOMDB = false
        self.omdbModel = OMDBModel.defaultOMDB()
        print("????? COULD NOT GET POSTER DATA  ???")
      }
        
    } catch {
      print("failed to get data from Url Task. Error: \(error)")
    }
  
  }
}

//-------------------------------------------------------------
// A generic parsing service to fetch data from a URLSession
//-------------------------------------------------------------
enum NetworkError: Error {
  case badUrl
  case invalidRequest
  case badResponse
  case badStatus
  case failedToDecodeResponse
}

//@MainActor
class WebService: Codable {
  func downloadData<T: Codable>(fromURL: String) async -> T? {
    do {
      guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
      let (data, response) = try await URLSession.shared.data(from: url)
      guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
      guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
      guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecodeResponse }
      
      return decodedResponse
    } catch NetworkError.badUrl {
      print("There was an error creating the URL")
    } catch NetworkError.badResponse {
      print("Did not get a valid response")
    } catch NetworkError.badStatus {
      print("Did not get a 2xx status code from the response")
    } catch NetworkError.failedToDecodeResponse {
      print("Failed to decode response into the given type")
    } catch {
      print("An error occured downloading the data")
    }
    
    return nil
  }
}
