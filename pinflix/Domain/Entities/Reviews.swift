//
//  Reviews.swift
//  pinflix
//
//  Created by Panji Yoga on 15/03/23.
//

struct Reviews: Codable {
    let id, page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    struct Result: Codable {
        let author: String?
        let authorDetails: AuthorDetails?
        let content, createdAt, id, updatedAt: String?
        let url: String?
        
        enum CodingKeys: String, CodingKey {
            case author
            case authorDetails = "author_details"
            case content
            case createdAt = "created_at"
            case id
            case updatedAt = "updated_at"
            case url
        }
        
        struct AuthorDetails: Codable {
            let name, username: String?
            let avatarPath: String?
            let rating: Int?
            
            enum CodingKeys: String, CodingKey {
                case name, username
                case avatarPath = "avatar_path"
                case rating
            }
        }
    }
}
