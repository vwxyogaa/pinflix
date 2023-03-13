//
//  Repository.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation
import RxSwift

protocol RepositoryProtocol {
    // MARK: - remote
    func getNowPlaying() -> Observable<TMDB>
    func getPopular() -> Observable<TMDB>
}

final class Repository: NSObject {
    typealias MovieInstance = (RemoteDataSource) -> Repository
    fileprivate let remote: RemoteDataSource
    
    init(remote: RemoteDataSource) {
        self.remote = remote
    }
    
    static let sharedInstance: MovieInstance = { remote in
        return Repository(remote: remote)
    }
}

extension Repository: RepositoryProtocol {
    // MARK: - remote
    func getNowPlaying() -> Observable<TMDB> {
        return remote.getNowPlaying()
    }
    
    func getPopular() -> Observable<TMDB> {
        return remote.getPopular()
    }
}
