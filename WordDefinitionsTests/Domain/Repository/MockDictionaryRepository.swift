//
//  MockDictionaryRepository.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

@testable import WordDefinitions
import Foundation
import Combine

class MockDictionaryRepository: DictionaryRepository {
    var isConnected = false
    var mockDefinitions: [WordDefinition] = []

    func getDefinition(for word: String) -> AnyPublisher<[WordDefinition], Error> {
        Just(mockDefinitions).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func getPastSearchWords() -> AnyPublisher<[String], Error> {
        Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func isConnectedToNetwork() -> AnyPublisher<Bool, Never> {
        Just(isConnected).eraseToAnyPublisher()
    }
}
