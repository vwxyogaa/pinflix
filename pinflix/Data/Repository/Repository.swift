//
//  Repository.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    // MARK: - remote
    func getNowPlaying(page: Int) -> Observable<TMDB>
    func getPopular(page: Int) -> Observable<TMDB>
    func getTopRated(page: Int) -> Observable<TMDB>
    func getDetail(id: Int) -> Observable<Movie>
    func search(query: String?) -> Observable<TMDB>
    func getUpcoming(page: Int) -> Observable<TMDB>
    func getCredits(id: Int) -> Observable<Credits>
    func getReviews(id: Int) -> Observable<Reviews>
    func getRecommendations(id: Int) -> Observable<Recommendations>
}

final class Repository: NSObject {
    typealias MovieInstance = (RemoteDataSource) -> Repository
    fileprivate let remote: RemoteDataSource
    
    init(remote: RemoteDataSource) {
        self.remote = remote
    }
    
    static let sharedInstance: MovieInstance = { remote in
        return Repository(remote: remote)
    }
}

extension Repository: RepositoryProtocol {
    // MARK: - remote
    func getNowPlaying(page: Int) -> Observable<TMDB> {
        return remote.getNowPlaying(page: page)
    }
    
    func getPopular(page: Int) -> Observable<TMDB> {
        return remote.getPopular(page: page)
    }
    
    func getTopRated(page: Int) -> Observable<TMDB> {
        return remote.getTopRated(page: page)
    }
    
    func getDetail(id: Int) -> Observable<Movie> {
        return remote.getDetail(id: id)
    }
    
    func search(query: String?) -> Observable<TMDB> {
        return remote.search(query: query)
    }
    
    func getUpcoming(page: Int) -> Observable<TMDB> {
        return remote.getUpcoming(page: page)
    }
    
    func getCredits(id: Int) -> Observable<Credits> {
        return remote.getCredits(id: id)
    }
    
    func getReviews(id: Int) -> Observable<Reviews> {
        return remote.getReviews(id: id)
    }
    
    func getRecommendations(id: Int) -> Observable<Recommendations> {
        return remote.getRecommendations(id: id)
    }
}
