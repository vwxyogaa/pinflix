//
//  BaseViewModel.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import RxRelay
import RxCocoa

class BaseViewModel {
    let _isLoading = BehaviorRelay<Bool>(value: false)
    let _errorMessage = BehaviorRelay<String?>(value: nil)
    
    var isLoading: Driver<Bool> {
        return _isLoading.asDriver()
    }
    var errorMessage: String? {
        return _errorMessage.value
    }
}
