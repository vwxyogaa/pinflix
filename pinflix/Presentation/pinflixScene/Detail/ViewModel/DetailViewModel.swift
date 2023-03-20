//
//  DetailViewModel.swift
//  pinflix
//
//  Created by Panji Yoga on 13/03/23.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let detailUseCase: DetailUseCaseProtocol
    
    private let _movie = BehaviorRelay<Movie?>(value: nil)
    private let _casts = BehaviorRelay<[Credits.Cast]?>(value: nil)
    private let _reviews = BehaviorRelay<[Reviews.Result]?>(value: nil)
    private let _recommendations = BehaviorRelay<[Recommendations.Result]?>(value: nil)
    private let _backdrops = BehaviorRelay<[Images.Backdrop]?>(value: nil)
    private let _posters = BehaviorRelay<[Images.Backdrop]?>(value: nil)
    private let _videos = BehaviorRelay<[Videos.Result]?>(value: nil)
    private let _isSaved = BehaviorRelay<Bool>(value: false)
    
    init(detailUseCase: DetailUseCaseProtocol) {
        self.detailUseCase = detailUseCase
        super.init()
    }
}

extension DetailViewModel {
    // MARK: - Detail
    var movie: Driver<Movie?> {
        return _movie.asDriver()
    }
    
    func getDetail(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getDetail(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self._movie.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    // MARK: - Credit Casts
    var casts: Driver<[Credits.Cast]?> {
        return _casts.asDriver()
    }
    
    var castCount: Int {
        return _casts.value?.count ?? 0
    }
    
    func cast(at index: Int) -> Credits.Cast? {
        return _casts.value?[safe: index]
    }
    
    func getCredits(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getCredits(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self._casts.accept(result.cast)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    // MARK: - Reviews
    var reviews: Driver<[Reviews.Result]?> {
        return _reviews.asDriver()
    }
    
    var reviewCount: Int {
        return _reviews.value?.count ?? 0
    }
    
    func review(at index: Int) -> Reviews.Result? {
        return _reviews.value?[safe: index]
    }
    
    func getReviews(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getReviews(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self._reviews.accept(result.results)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    // MARK: - Recommendations
    var recommendations: Driver<[Recommendations.Result]?> {
        return _recommendations.asDriver()
    }
    
    var recommendationCount: Int {
        return _recommendations.value?.count ?? 0
    }
    
    func recommendation(at index: Int) -> Recommendations.Result? {
        return _recommendations.value?[safe: index]
    }
    
    func getRecommendations(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getRecommendations(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self._recommendations.accept(result.results)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
                print(error)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    // MARK: - Images Backdrops
    var backdrops: Driver<[Images.Backdrop]?> {
        return _backdrops.asDriver()
    }
    
    var backdropCount: Int {
        return _backdrops.value?.count ?? 0
    }
    
    func backdrop(at index: Int) -> Images.Backdrop? {
        return _backdrops.value?[safe: index]
    }
    
    // MARK: - Images Posters
    var posters: Driver<[Images.Backdrop]?> {
        return _posters.asDriver()
    }
    
    var posterCount: Int {
        return _posters.value?.count ?? 0
    }
    
    func poster(at index: Int) -> Images.Backdrop? {
        return _posters.value?[safe: index]
    }
    
    func getImages(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getImages(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self._backdrops.accept(result.backdrops)
                self._posters.accept(result.posters)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    // MARK: - Videos
    var videos: Driver<[Videos.Result]?> {
        return _videos.asDriver()
    }
    
    var videoCount: Int {
        return _videos.value?.count ?? 0
    }
    
    func video(at index: Int) -> Videos.Result? {
        return _videos.value?[safe: index]
    }
    
    func getVideos(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getVideos(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self._videos.accept(result.results)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
                print(error)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    // MARK: - isSaved
    var isSaved: Driver<Bool> {
        return _isSaved.asDriver()
    }
    
    func checkMovieInCollection(id: Int?) {
        guard let id else { return }
        detailUseCase.checkMovieInCollection(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isSaved.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func addToCollection() {
        guard let movie = _movie.value else { return }
        detailUseCase.addToCollection(movie: movie)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isSaved.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func deleteFromCollection() {
        guard let id = _movie.value?.id else { return }
        detailUseCase.deleteFromCollection(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isSaved.accept(!result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
