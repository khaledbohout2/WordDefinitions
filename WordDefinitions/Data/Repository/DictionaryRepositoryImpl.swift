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
    private let networkMonitor: NetworkMonitorProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published private var isConnected: Bool = true

    init(local: DictionaryLocalDataSource, remote: DictionaryRemoteDataSource, networkMonitor: NetworkMonitorProtocol) {
        self.localDataSource = local
        self.remoteDataSource = remote
        self.networkMonitor = networkMonitor

        networkMonitor.isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)
    }

    func getDefinition(for word: String) -> AnyPublisher<[WordDefinition], Error> {
        return fetchCachedDefinition(for: word)
            .flatMap { cachedDefinitions -> AnyPublisher<[WordDefinition], Error> in
                if cachedDefinitions.isEmpty {
                    return self.fetchRemoteDefinitionIfOnline(for: word)
                        .catch { error -> AnyPublisher<[WordDefinition], Error> in
                            return Fail(error: error).eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
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
        guard isConnected else {
            return Fail(error: NetworkError.noInternet).eraseToAnyPublisher()
        }

        return remoteDataSource.fetchDefinition(for: word)
            .flatMap { definitions in
                Future<Void, Never> { promise in
                    do {
                        try self.localDataSource.saveDefinitions(definitions)
                        promise(.success(()))
                    } catch {
                        print("❌ Save Definitions Error: \(error)")
                    }
                }
                .map { _ in definitions }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func getPastSearchWords() -> AnyPublisher<[String], Error> {
        localDataSource.fetchRecentSearches()
    }

    func isConnectedToNetwork() -> AnyPublisher<Bool, Never> {
        return networkMonitor.isConnectedPublisher
    }

}
