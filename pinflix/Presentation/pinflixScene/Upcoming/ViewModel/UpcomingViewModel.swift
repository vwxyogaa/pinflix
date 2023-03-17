//
//  UpcomingViewModel.swift
//  pinflix
//
//  Created by Panji Yoga on 14/03/23.
//

import Foundation
import RxSwift
import RxCocoa

class UpcomingViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let upcomingUseCase: UpcomingUseCaseProtocol
    private let detailUseCase: DetailUseCaseProtocol
    
    private let _upcomings = BehaviorRelay<[TMDB.Results]?>(value: nil)
    
    // MARK: - Pagination
    private var upcomingResults = [TMDB.Results]()
    private var upcomingResultsCount = 0
    private var upcomingPage = 1
    private var upcomingCanLoadNextPage = false
    
    init(upcomingUseCase: UpcomingUseCaseProtocol, detailUseCase: DetailUseCaseProtocol) {
        self.upcomingUseCase = upcomingUseCase
        self.detailUseCase = detailUseCase
        super.init()
        getUpcoming()
    }
    
    func refresh() {
        upcomingResults = []
        upcomingResultsCount = 0
        upcomingPage = 1
        getUpcoming()
    }
}

extension UpcomingViewModel {
    var upcomings: Driver<[TMDB.Results]?> {
        return _upcomings.asDriver()
    }
    
    var upcomingCount: Int {
        return _upcomings.value?.count ?? 0
    }
    
    func upcoming(at index: Int) -> TMDB.Results? {
        return _upcomings.value?[safe: index]
    }
    
    func getUpcoming() {
        self._isLoading.accept(true)
        upcomingUseCase.getUpcoming(page: upcomingPage)
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._isLoading.accept(false)
                self.upcomingResults.append(contentsOf: result.results)
                self.upcomingResultsCount += result.results.count
                if self.upcomingResults.count == self.upcomingResultsCount {
                    self.upcomingPage += 1
                    self.upcomingCanLoadNextPage = false
                    self._upcomings.accept(self.upcomingResults)
                }
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func loadMovieNextPage(index: Int) {
        if !upcomingCanLoadNextPage {
            if upcomingCount - 2 == index {
                upcomingCanLoadNextPage = true
                getUpcoming()
            }
        }
    }
}
