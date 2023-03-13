//
//  DashboardViewModel.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let dashboardUseCase: DashboardUseCaseProtocol
    
    private let _nowPlayings = BehaviorRelay<[TMDB.Results]?>(value: nil)
    private let _populars = BehaviorRelay<[TMDB.Results]?>(value: nil)
    private let _topRateds = BehaviorRelay<[TMDB.Results]?>(value: nil)
    
    init(dashboardUseCase: DashboardUseCaseProtocol) {
        self.dashboardUseCase = dashboardUseCase
        super.init()
        getNowPlaying()
        getPopular()
        getTopRated()
    }
}

// MARK: - now playing
extension DashboardViewModel {
    var nowPlayings: Driver<[TMDB.Results]?> {
        return _nowPlayings.asDriver()
    }
    
    var nowPlayingCount: Int {
        return _nowPlayings.value?.count ?? 0
    }
    
    func nowPlaying(at index: Int) -> TMDB.Results? {
        return _nowPlayings.value?[safe: index]
    }
    
    func getNowPlaying() {
        dashboardUseCase.getNowPlaying()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._nowPlayings.accept(result.results)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - popular
extension DashboardViewModel {
    var populars: Driver<[TMDB.Results]?> {
        return _populars.asDriver()
    }
    
    var popularCount: Int {
        return _populars.value?.count ?? 0
    }
    
    func popular(at index: Int) -> TMDB.Results? {
        return _populars.value?[safe: index]
    }
    
    func getPopular() {
        dashboardUseCase.getPopular()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._populars.accept(result.results)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - top rated
extension DashboardViewModel {
    var topRateds: Driver<[TMDB.Results]?> {
        return _topRateds.asDriver()
    }
    
    var topRatedCount: Int {
        return _topRateds.value?.count ?? 0
    }
    
    func topRated(at index: Int) -> TMDB.Results? {
        return _topRateds.value?[safe: index]
    }
    
    func getTopRated() {
        dashboardUseCase.getTopRated()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._topRateds.accept(result.results)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
