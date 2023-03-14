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
    
    // MARK: - pagination
    // now playing
    private var nowPlayingResults = [TMDB.Results]()
    private var nowPlayingResultsCount = 0
    private var nowPlayingPage = 1
    private var nowPlayingCanLoadNextPage = false
    
    // popular
    private var popularResults = [TMDB.Results]()
    private var popularResultsCount = 0
    private var popularPage = 1
    private var popularCanLoadNextPage = false
    
    // top rated
    private var topRatedResults = [TMDB.Results]()
    private var topRatedResultsCount = 0
    private var topRatedPage = 1
    private var topRatedCanLoadNextPage = false
    
    init(dashboardUseCase: DashboardUseCaseProtocol) {
        self.dashboardUseCase = dashboardUseCase
        super.init()
        getNowPlaying()
        getPopular()
        getTopRated()
    }
    
    func refresh() {
        nowPlayingResults = []
        nowPlayingResultsCount = 0
        nowPlayingPage = 1
        
        popularResults = []
        popularResultsCount = 0
        popularPage = 1
        
        topRatedResults = []
        topRatedResultsCount = 0
        topRatedPage = 1
        
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
        self._isLoading.accept(true)
        dashboardUseCase.getNowPlaying(page: nowPlayingPage)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self.nowPlayingResults.append(contentsOf: result.results)
                self.nowPlayingResultsCount += result.results.count
                if self.nowPlayingResults.count == self.nowPlayingResultsCount {
                    self.nowPlayingPage += 1
                    self.nowPlayingCanLoadNextPage = false
                    self._nowPlayings.accept(self.nowPlayingResults)
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func loadNowPlayingNextPage(index: Int) {
        if !nowPlayingCanLoadNextPage {
            if nowPlayingCount - 2 == index {
                nowPlayingCanLoadNextPage = true
                getNowPlaying()
            }
        }
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
        self._isLoading.accept(true)
        dashboardUseCase.getPopular(page: popularPage)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self.popularResults.append(contentsOf: result.results)
                self.popularResultsCount += result.results.count
                if self.popularResults.count == self.popularResultsCount {
                    self.popularPage += 1
                    self.popularCanLoadNextPage = false
                    self._populars.accept(self.popularResults)
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func loadPopularNextPage(index: Int) {
        if !popularCanLoadNextPage {
            if popularCount - 2 == index {
                popularCanLoadNextPage = true
                getPopular()
            }
        }
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
        self._isLoading.accept(true)
        dashboardUseCase.getTopRated(page: topRatedPage)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self.topRatedResults.append(contentsOf: result.results)
                self.topRatedResultsCount += result.results.count
                if self.topRatedResults.count == self.topRatedResultsCount {
                    self.topRatedPage += 1
                    self.topRatedCanLoadNextPage = false
                    self._topRateds.accept(self.topRatedResults)
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func loadTopRatedNextPage(index: Int) {
        if !topRatedCanLoadNextPage {
            if topRatedCount - 2 == index {
                topRatedCanLoadNextPage = true
                getTopRated()
            }
        }
    }
}
