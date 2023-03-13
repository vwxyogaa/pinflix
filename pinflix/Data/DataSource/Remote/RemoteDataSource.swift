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
}
