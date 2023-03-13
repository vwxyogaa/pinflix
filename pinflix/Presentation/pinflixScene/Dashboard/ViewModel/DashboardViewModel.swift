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
    
    init(dashboardUseCase: DashboardUseCaseProtocol) {
        self.dashboardUseCase = dashboardUseCase
        super.init()
        getNowPlaying()
    }
    
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
