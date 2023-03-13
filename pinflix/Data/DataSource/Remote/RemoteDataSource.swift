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
    
    func getNowPlaying() -> Observable<TMDB> {
        let url = URL(string: baseUrl + "/movie/now_playing")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getPopular() -> Observable<TMDB> {
        let url = URL(string: baseUrl + "/movie/popular")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
    
    func getTopRated() -> Observable<TMDB> {
        let url = URL(string: baseUrl + "/movie/top_rated")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get)
        return data
    }
}
