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
    
    init(detailUseCase: DetailUseCaseProtocol) {
        self.detailUseCase = detailUseCase
        super.init()
    }
    
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
