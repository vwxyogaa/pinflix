//
//  Images.swift
//  pinflix
//
//  Created by Panji Yoga on 16/03/23.
//

struct Images: Codable {
    let backdrops: [Backdrop]
    let id: Int
    let logos, posters: [Backdrop]
    
    struct Backdrop: Codable {
        let aspectRatio: Double?
        let height: Int?
        let iso639_1: String?
        let filePath: String?
        let voteAverage: Double?
        let voteCount, width: Int?
        
        enum CodingKeys: String, CodingKey {
            case aspectRatio = "aspect_ratio"
            case height
            case iso639_1 = "iso_639_1"
            case filePath = "file_path"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case width
        }
    }
}
