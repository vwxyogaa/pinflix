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
    func getReviews(id: Int) -> Observable<Reviews>
    func getRecommendations(id: Int) -> Observable<Recommendations>
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
    
    func getReviews(id: Int) -> Observable<Reviews> {
        return self.repository.getReviews(id: id)
    }
    
    func getRecommendations(id: Int) -> Observable<Recommendations> {
        return self.repository.getRecommendations(id: id)
    }
}
