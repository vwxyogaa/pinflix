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
    
    init(dashboardUseCase: DashboardUseCaseProtocol) {
        self.dashboardUseCase = dashboardUseCase
        super.init()
        getNowPlaying()
        getPopular()
    }
    
    // MARK: - now playing
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
    
    // MARK: - popular
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
