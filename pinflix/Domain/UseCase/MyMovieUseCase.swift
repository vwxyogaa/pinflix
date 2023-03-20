//
//  MyMovieUseCase.swift
//  pinflix
//
//  Created by Panji Yoga on 20/03/23.
//

import Foundation
import RxSwift

protocol MyMovieUseCaseProtocol {
    func getCollection() -> Observable<[Movie]>
}

class MyMovieUseCase: MyMovieUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getCollection() -> Observable<[Movie]> {
        return repository.getCollection()
    }
}
