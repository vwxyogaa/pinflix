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
    private let _crew = BehaviorRelay<[Credits.Cast]?>(value: nil)
    private let _images = BehaviorRelay<[Images.Backdrop]?>(value: nil)
    
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
    
    // MARK: - Credit Crew
    var crew: Driver<[Credits.Cast]?> {
        return _crew.asDriver()
    }
    
    func getCredits(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getCredits(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self._casts.accept(result.cast)
                self._crew.accept(result.crew)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

extension DetailViewModel {
    // MARK: - Images
    var images: Driver<[Images.Backdrop]?> {
        return _images.asDriver()
    }
    
    var imageCount: Int {
        return _images.value?.count ?? 0
    }
    
    func image(at index: Int) -> Images.Backdrop? {
        return _images.value?[safe: index]
    }
    
    func getImages(id: Int) {
        self._isLoading.accept(true)
        detailUseCase.getImages(id: id)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self._images.accept(result.backdrops)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
