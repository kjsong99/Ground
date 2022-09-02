// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tvResponse = try? newJSONDecoder().decode(TvResponse.self, from: jsonData)

import Foundation

// MARK: - TvResponse
struct TvResponse: Codable {
    let page: Int
    let results: [TvResult]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages
        case totalResults
    }

    init(page: Int, results: [TvResult], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - TV Result
struct TvResult: Codable {
    let backdropPath, firstAirDate: String
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [OriginCountry]
    let originalLanguage: OriginalLanguage
    let originalName, overview: String
    let popularity: Double
    let posterPath: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath
        case firstAirDate
        case genreIDS
        case id, name
        case originCountry
        case originalLanguage
        case originalName
        case overview, popularity
        case posterPath
        case voteAverage
        case voteCount
    }
    
    enum OriginCountry: String, Codable {
        case gs = "GS"
        case kr = "KR"
    }

    enum OriginalLanguage: String, Codable {
        case ko = "ko"
    }



    init(backdropPath: String, firstAirDate: String, genreIDS: [Int], id: Int, name: String, originCountry: [OriginCountry], originalLanguage: OriginalLanguage, originalName: String, overview: String, popularity: Double, posterPath: String, voteAverage: Double, voteCount: Int) {
        self.backdropPath = backdropPath
        self.firstAirDate = firstAirDate
        self.genreIDS = genreIDS
        self.id = id
        self.name = name
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

