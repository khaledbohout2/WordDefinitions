//
//  FetchWordUseCase.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import Combine

protocol FetchWordUseCase {
    func execute(word: String) -> AnyPublisher<[WordDefinition], Error>
}

class FetchWordUseCaseImplement: FetchWordUseCase {
    private let repository: DictionaryRepository

    init(repository: DictionaryRepository) {
        self.repository = repository
    }
    
    func execute(word: String) -> AnyPublisher<[WordDefinition], Error> {
        repository.getDefinition(for: word)
    }
}

