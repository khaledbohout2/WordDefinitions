//
//  DictionaryRemoteDataSource.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import Moya
import Combine

protocol DictionaryRemoteDataSource {
    func fetchDefinition(for word: String) -> AnyPublisher<[WordDefinition], Error>
}

class DictionaryRemoteDataSourceImpl: DictionaryRemoteDataSource {
    private let provider: MoyaProvider<DictionaryAPI>

    init(provider: MoyaProvider<DictionaryAPI>) {
        self.provider = provider
    }

    func fetchDefinition(for word: String) -> AnyPublisher<[WordDefinition], Error> {
        return provider.requestPublisher(.search(word: word))
            .tryMap { response in
                guard (200...299).contains(response.statusCode) else {
                    throw NetworkError.requestFailed(NSError(domain: "", code: response.statusCode, userInfo: nil))
                }
                return response.data
            }
            .decode(type: [WordDefinition].self, decoder: JSONDecoder())
            .mapError { error in
                NetworkError.decodingFailed(error)
            }
            .eraseToAnyPublisher()
    }
}
