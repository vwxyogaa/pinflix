//
//  DetailUseCase.swift
//  pinflix
//
//  Created by Panji Yoga on 13/03/23.
//

import RxSwift

protocol DetailUseCaseProtocol {
    // MARK: - Remote
    func getDetail(id: Int) -> Observable<Movie>
    func getCredits(id: Int) -> Observable<Credits>
    func getReviews(id: Int) -> Observable<Reviews>
    func getRecommendations(id: Int) -> Observable<Recommendations>
    func getImages(id: Int) -> Observable<Images>
    func getVideos(id: Int) -> Observable<Videos>
    // MARK: - Locale
    func checkMovieInCollection(id: Int) -> Observable<Bool>
    func addToCollection(movie: Movie) -> Observable<Bool>
    func deleteFromCollection(id: Int) -> Observable<Bool>
}

final class DetailUseCase: DetailUseCaseProtocol {
    private let repository: RepositoryProtocol
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Remote
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
    
    func getImages(id: Int) -> Observable<Images> {
        return self.repository.getImages(id: id)
    }
    
    func getVideos(id: Int) -> Observable<Videos> {
        return self.repository.getVideos(id: id)
    }
    
    // MARK: - Locale
    func checkMovieInCollection(id: Int) -> Observable<Bool> {
        return repository.checkMovieInCollection(id: id)
    }
    
    func addToCollection(movie: Movie) -> Observable<Bool> {
        return repository.addToCollection(movie: movie)
    }
    
    func deleteFromCollection(id: Int) -> Observable<Bool> {
        return repository.deleteFromCollection(id: id)
    }
}
