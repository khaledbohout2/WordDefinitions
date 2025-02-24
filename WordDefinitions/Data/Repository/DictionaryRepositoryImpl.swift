//
//  DictionaryRepositoryImpl.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import Combine
import CoreData

class DictionaryRepositoryImpl: DictionaryRepository {
    private let localDataSource: DictionaryLocalDataSource
    private let remoteDataSource: DictionaryRemoteDataSource
    private let networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()
    @Published private var isConnected: Bool = true

    init(local: DictionaryLocalDataSource, remote: DictionaryRemoteDataSource, networkMonitor: NetworkMonitor) {
        self.localDataSource = local
        self.remoteDataSource = remote
        self.networkMonitor = networkMonitor

        networkMonitor.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)
    }

    func getDefinition(for word: String) -> AnyPublisher<[WordDefinition], Error> {
        fetchCachedDefinition(for: word)
            .flatMap { cachedDefinitions -> AnyPublisher<[WordDefinition], Error> in
                if cachedDefinitions.isEmpty {
                    return self.fetchRemoteDefinitionIfOnline(for: word)
                } else {
                    return Just(cachedDefinitions)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func fetchCachedDefinition(for word: String) -> AnyPublisher<[WordDefinition], Error> {
        localDataSource.fetchDefinition(for: word)
            .map { $0.map { $0.toWordDefinition() } }
            .eraseToAnyPublisher()
    }

    private func fetchRemoteDefinitionIfOnline(for word: String) -> AnyPublisher<[WordDefinition], Error> {
        isConnected ? remoteDataSource.fetchDefinition(for: word)
            .handleEvents(receiveOutput: { definitions in
                self.localDataSource.saveDefinitions(definitions)
            })
            .eraseToAnyPublisher()
            : Fail(error: NetworkError.noInternet).eraseToAnyPublisher()
    }

    func getPastSearchWords() -> AnyPublisher<[String], Error> {
        localDataSource.fetchRecentSearches()
    }

    func isConnectedToNetwork() -> AnyPublisher<Bool, Never> {
        return networkMonitor.isConnectedPublisher
    }
}


