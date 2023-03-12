//
//  DashboardUseCase.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation
import RxSwift

protocol DashboardUseCaseProtocol {
    func getNowPlaying() -> Observable<[TMDB.Results]>
}

final class DashboardUseCase: DashboardUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getNowPlaying() -> Observable<[TMDB.Results]> {
        return self.repository.getNowPlaying()
    }
}