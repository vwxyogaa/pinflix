//
//  SearchUseCase.swift
//  pinflix
//
//  Created by Panji Yoga on 13/03/23.
//

import Foundation
import RxSwift

protocol SearchUseCaseProtocol {
    func search(query: String?) -> Observable<TMDB>
}

final class SearchUseCase: SearchUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func search(query: String?) -> Observable<TMDB> {
        return self.repository.search(query: query)
    }
}
