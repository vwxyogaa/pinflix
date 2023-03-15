//
//  DetailUseCase.swift
//  pinflix
//
//  Created by Panji Yoga on 13/03/23.
//

import Foundation
import RxSwift

protocol DetailUseCaseProtocol {
    func getDetail(id: Int) -> Observable<Movie>
    func getCredits(id: Int) -> Observable<Credits>
    func getImages(id: Int) -> Observable<Images>
}

final class DetailUseCase: DetailUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func getDetail(id: Int) -> Observable<Movie> {
        return self.repository.getDetail(id: id)
    }
    
    func getCredits(id: Int) -> Observable<Credits> {
        return self.repository.getCredits(id: id)
    }
    
    func getImages(id: Int) -> Observable<Images> {
        return self.repository.getImages(id: id)
    }
}
