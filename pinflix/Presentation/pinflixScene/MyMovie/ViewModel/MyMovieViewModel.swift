//
//  MyMovieViewModel.swift
//  pinflix
//
//  Created by Panji Yoga on 20/03/23.
//

import Foundation
import RxSwift
import RxCocoa

class MyMovieViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let myMovieUseCase: MyMovieUseCaseProtocol
    
    private let _movies = BehaviorRelay<[Movie]>(value: [])
    
    init(myMovieUseCase: MyMovieUseCaseProtocol) {
        self.myMovieUseCase = myMovieUseCase
    }
    
    var movies: Driver<[Movie]> {
        return _movies.asDriver()
    }
    
    var movieCount: Int {
        return _movies.value.count
    }
    
    func movie(at index: Int) -> Movie? {
        return _movies.value[safe: index]
    }
    
    func getMyCollection() {
        myMovieUseCase.getCollection()
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self._movies.accept(result)
            } onError: { error in
                self._errorMessage.accept(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
