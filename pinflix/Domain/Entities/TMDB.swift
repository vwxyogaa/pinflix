//
//  TMDB.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation

struct TMDB: Codable {
    let dates: Dates
    let page: Int
    let results: [Results]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    struct Dates: Codable {
        let maximum: String
        let minimum: String
    }
    
    struct Results: Codable {
        let adult: String
        let backdropPath: String
        let genreIds: [Int]
        let id: Int
        let originalLanguage: String
        let originalTitle: String
        let overview: String
        let popularity: Int
        let posterPath: String
        let releaseDate: String
        let title: String
        let video: Bool
        let voteAverage: Int
        let voteCount: Int
        
        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIds = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview
            case popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title
            case video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }
}
