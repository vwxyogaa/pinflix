//
//  AttributeImages.swift
//  pinflix
//
//  Created by Panji Yoga on 17/03/23.
//

import Foundation

extension TMDB.Results {
    var posterPathImage: String? {
        get {
            guard let posterPath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + posterPath
        }
    }
    
    var backdropPathImage: String? {
        get {
            guard let backdropPath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + backdropPath
        }
    }
}

extension Recommendations.Result {
    var posterPathImage: String? {
        get {
            guard let posterPath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + posterPath
        }
    }
}

extension Reviews.Result.AuthorDetails {
    var avatarPathImage: String? {
        get {
            guard let avatarPath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + avatarPath
        }
    }
}

extension Credits.Cast {
    var profilePathImage: String? {
        get {
            guard let profilePath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + profilePath
        }
    }
}

extension Images.Backdrop {
    var filePathImage: String? {
        get {
            guard let filePath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + filePath
        }
    }
}

extension Movie {
    var posterPathImage: String? {
        get {
            guard let posterPath else { return "" }
            return Constants.baseImageUrl + Constants.imagePath.w500 + posterPath
        }
    }
}
