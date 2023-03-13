//
//  RemoteDataSource.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation
import RxSwift

final class RemoteDataSource {
    private let baseUrl = "https://api.themoviedb.org/3/movie"
    private let apiKey = "3ff97919634cab922c295f2d9b5ff64a"
    
    func getNowPlaying() -> Observable<TMDB> {
        let url = URL(string: baseUrl + "/now_playing?api_key=\(apiKey)")!
        let data: Observable<TMDB> = APIManager.shared.executeQuery(url: url, method: .get, params: nil)
        return data
    }
}
