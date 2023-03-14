//
//  UpcomingUseCase.swift
//  pinflix
//
//  Created by Panji Yoga on 14/03/23.
//

import Foundation
import RxSwift

protocol UpcomingUseCaseProtocol {
    func getUpcoming(page: Int) -> Observable<TMDB>
}

final class UpcomingUseCase: UpcomingUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getUpcoming(page: Int) -> Observable<TMDB> {
        return self.repository.getUpcoming(page: page)
    }
}
