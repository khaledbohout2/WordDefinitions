//
//  DictionaryCoordinator.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import Foundation
import Combine
import SwiftUI
import CoreData
import Moya

class DictionaryCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigateToDefinition(word: String) {
        path.append(word)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func reset() {
        path.removeLast(path.count)
    }
}

extension DictionaryCoordinator {
    func start() -> DictionaryView {
        let context = PersistenceController.shared.container.viewContext
        let localDataSource = DictionaryLocalDataSourceImpl(context: context)
        let remoteDataSource = DictionaryRemoteDataSourceImpl(provider: MoyaProvider<DictionaryAPI>())
        let repository = DictionaryRepositoryImpl(local: localDataSource, remote: remoteDataSource, networkMonitor: NetworkMonitor())
        let CheckNetworkStatusUseCase = CheckNetworkStatusUseCaseImplement(repository: repository)
        let FetchPastSearchWordsUseCase = FetchPastSearchWordsUseCaseImplement(localDataSource: localDataSource)
        let fetchWordUseCase = FetchWordUseCaseImplement(repository: repository)
        let viewModel = DictionaryViewModel(fetchWordUseCase: fetchWordUseCase, fetchPastSearchWordsUseCase: FetchPastSearchWordsUseCase, checkNetworkStatusUseCase: CheckNetworkStatusUseCase)
        return DictionaryView(viewModel: viewModel)
    }
}
