//
//  APIManager.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation
import Alamofire
import RxSwift

final class APIManager {
    static let shared = APIManager()
    
    func executeQuery<T> (url: URL, method: HTTPMethod, params: Parameters?) -> Observable<T> where T: Decodable {
        return Observable<T>.create { observer in
            AF.request(url, method: method, parameters: params).validate().responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
