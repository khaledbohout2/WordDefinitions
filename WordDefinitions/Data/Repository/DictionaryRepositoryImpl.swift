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

    init(local: DictionaryLocalDataSource, remote: DictionaryRemoteDataSource) {
        self.localDataSource = local
        self.remoteDataSource = remote
    }

    func getDefinition(for word: String) -> AnyPublisher<[WordDefinition], Error> {
        localDataSource.fetchDefinition(for: word)
            .map { $0.map { $0.toWordDefinition() } }
            .flatMap { cachedDefinitions -> AnyPublisher<[WordDefinition], Error> in
                if cachedDefinitions.isEmpty {
                    return self.remoteDataSource.fetchDefinition(for: word)
                        .handleEvents(receiveOutput: {
                            self.localDataSource.saveDefinitions($0)
                        })
                        .eraseToAnyPublisher()
                } else {
                    return Just(cachedDefinitions)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

}
