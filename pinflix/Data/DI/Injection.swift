//
//  Injection.swift
//  pinflix
//
//  Created by yxgg on 12/03/23.
//

import Foundation

final class Injection {
    func provideDashboardUseCase() -> DashboardUseCaseProtocol {
        let repository = provideRepository()
        return DashboardUseCase(repository: repository)
    }
    
    func provideDetailUseCase() -> DetailUseCaseProtocol {
        let repository = provideRepository()
        return DetailUseCase(repository: repository)
    }
    
    func provideSearchUseCase() -> SearchUseCaseProtocol {
        let repository = provideRepository()
        return SearchUseCase(repository: repository)
    }
    
    func provideUpcomingUseCase() -> UpcomingUseCaseProtocol {
        let repository = provideRepository()
        return UpcomingUseCase(repository: repository)
    }
}

extension Injection {
    func provideRepository() -> RepositoryProtocol {
        let remoteDataSource = RemoteDataSource()
        return Repository.sharedInstance(remoteDataSource)
    }
}
