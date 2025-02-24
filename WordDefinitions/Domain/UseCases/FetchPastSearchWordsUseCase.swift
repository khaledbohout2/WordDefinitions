//
//  FetchPastSearchWordsUseCase.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import Combine

protocol FetchPastSearchWordsUseCase {
    func execute() -> AnyPublisher<[String], Error>
}

class FetchPastSearchWordsUseCaseImplement: FetchPastSearchWordsUseCase {
    private let localDataSource: DictionaryLocalDataSource
    
    init(localDataSource: DictionaryLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func execute() -> AnyPublisher<[String], Error> {
        localDataSource.fetchRecentSearches()
    }
}
