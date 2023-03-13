//
//  DashboardUseCase.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation
import RxSwift

protocol DashboardUseCaseProtocol {
    func getNowPlaying() -> Observable<TMDB>
    func getPopular() -> Observable<TMDB>
}

final class DashboardUseCase: DashboardUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getNowPlaying() -> Observable<TMDB> {
        return self.repository.getNowPlaying()
    }
    
    func getPopular() -> Observable<TMDB> {
        return self.repository.getPopular()
    }
}
