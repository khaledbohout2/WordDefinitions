//
//  CheckNetworkStatusUseCase.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import Combine

protocol CheckNetworkStatusUseCase {
    func execute() -> AnyPublisher<Bool, Never>
}

class CheckNetworkStatusUseCaseImplement: CheckNetworkStatusUseCase {
    private let repository: DictionaryRepository
    
    init(repository: DictionaryRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<Bool, Never> {
        repository.isConnectedToNetwork()
    }
}

