//
//  RemoteDataSource.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation
import RxSwift

final class RemoteDataSource {
    private let baseUrl = "https://api.themoviedb.org/3"
    
    func getNowPlaying(page: Int) -> Observable<TMDB> {
        let url = URL(string: baseUrl + "/movie/now_playing?page=\(page)")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getPopular(page: Int) -> Observable<TMDB> {
        let url = URL(string: baseUrl + "/movie/popular?page=\(page)")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getTopRated(page: Int) -> Observable<TMDB> {
        let url = URL(string: baseUrl + "/movie/top_rated?page=\(page)")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getDetail(id: Int) -> Observable<Movie> {
        let url = URL(string: baseUrl + "/movie/\(id)")!
        let data: Observable<Movie> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func search(query: String?) -> Observable<TMDB> {
        let url = URL(string: baseUrl + "/search/movie?query=\(query ?? "")") ?? URL(fileURLWithPath: "")
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getUpcoming(page: Int) -> Observable<TMDB> {
        let url = URL(string: baseUrl + "/movie/upcoming?page=\(page)")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getCredits(id: Int) -> Observable<Credits> {
        let url = URL(string: baseUrl + "/movie/\(id)/credits")!
        let data: Observable<Credits> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getReviews(id: Int) -> Observable<Reviews> {
        let url = URL(string: baseUrl + "/movie/\(id)/reviews")!
        let data: Observable<Reviews> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getRecommendations(id: Int) -> Observable<Recommendations> {
        let url = URL(string: baseUrl + "/movie/\(id)/recommendations")!
        let data: Observable<Recommendations> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
}
