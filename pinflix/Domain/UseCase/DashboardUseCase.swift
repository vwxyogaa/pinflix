//
//  DashboardUseCase.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import RxSwift

protocol DashboardUseCaseProtocol {
    func getNowPlaying(page: Int) -> Observable<TMDB>
    func getPopular(page: Int) -> Observable<TMDB>
    func getTopRated(page: Int) -> Observable<TMDB>
}

final class DashboardUseCase: DashboardUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getNowPlaying(page: Int) -> Observable<TMDB> {
        return self.repository.getNowPlaying(page: page)
    }
    
    func getPopular(page: Int) -> Observable<TMDB> {
        return self.repository.getPopular(page: page)
    }
    
    func getTopRated(page: Int) -> Observable<TMDB> {
        return self.repository.getTopRated(page: page)
    }
}
