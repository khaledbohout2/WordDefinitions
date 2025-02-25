//
//  MockDictionaryLocalDataSource.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

@testable import WordDefinitions
import Foundation
import Combine

class MockDictionaryLocalDataSource: DictionaryLocalDataSource {
    var mockDefinitions: [WordDefinitionEntity] = []
    var mockRecentSearches: [String] = []

    func fetchDefinition(for word: String) -> AnyPublisher<[WordDefinitionEntity], Error> {
        return Just(mockDefinitions.filter { $0.word == word })
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func saveDefinitions(_ definitions: [WordDefinition]) throws { }

    func fetchRecentSearches() -> AnyPublisher<[String], Error> {
        Just(mockRecentSearches).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
