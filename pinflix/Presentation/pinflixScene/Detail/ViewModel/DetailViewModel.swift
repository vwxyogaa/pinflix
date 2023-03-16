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
    // MARK: - Backdrops
    var backdrops: Driver<[Images.Backdrop]?> {
        return _backdrops.asDriver()
    }
    
    var backdropCount: Int {
        return _backdrops.value?.count ?? 0
    }
    
    func backdrop(at index: Int) -> Images.Backdrop? {
        return _backdrops.value?[safe: index]
    }
    
    // MARK: - Posters
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
