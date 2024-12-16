// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let oMDBModel = try? JSONDecoder().decode(OMDBModel.self, from: jsonData)

import Foundation

// MARK: - OMDBModel
struct OMDBModel: Codable {
    let title, year, rated, released: String
    let runtime, genre, director, writer: String
    let actors, plot, language, country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore, imdbRating, imdbVotes, imdbID: String
    let type, totalSeasons, response: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case totalSeasons
        case response = "Response"
    }
  static func defaultOMDB() -> OMDBModel {
    return OMDBModel(title: "", year: "", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", country: "", awards: "", poster: "", ratings: [], metascore: "", imdbRating: "", imdbVotes: "", imdbID: "", type: "", totalSeasons: "", response: "")
  }
  
  static func restryDefaultOMDB() -> OMDBModel {
    return OMDBModel(title: "", year: "", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", country: "", awards: "", poster: "????", ratings: [], metascore: "", imdbRating: "", imdbVotes: "", imdbID: "", type: "", totalSeasons: "", response: "")
  }
}

// MARK: - Rating
struct Rating: Codable {
    let source, value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}



