//
//  MockDictionaryRemoteDataSource.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

@testable import WordDefinitions
import Foundation
import Combine

class MockDictionaryRemoteDataSource: DictionaryRemoteDataSource {
    var mockDefinitions: [WordDefinition] = []

    func fetchDefinition(for word: String) -> AnyPublisher<[WordDefinition], Error> {
        Just(mockDefinitions).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
