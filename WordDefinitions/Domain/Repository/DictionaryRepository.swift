//
//  Untitled.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import Combine

protocol DictionaryRepository {
    func getDefinition(for word: String) -> AnyPublisher<[WordDefinition], Error>
    func getPastSearchWords() -> AnyPublisher<[String], Error>
    func isConnectedToNetwork() -> AnyPublisher<Bool, Never>
}
