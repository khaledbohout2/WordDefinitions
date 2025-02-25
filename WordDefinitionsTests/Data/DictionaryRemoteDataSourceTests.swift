//
//  DictionaryRemoteDataSourceTests.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

@testable import WordDefinitions
import Testing
import Combine
import Moya

struct DictionaryRemoteDataSourceTests {
    private var sut: DictionaryRemoteDataSourceImpl!
    private var provider: MoyaProvider<DictionaryAPI>!

    init() {
        provider = MoyaProvider<DictionaryAPI>(stubClosure: MoyaProvider.immediatelyStub)
        sut = DictionaryRemoteDataSourceImpl(provider: provider)
    }

    @Test func testFetchDefinition_Success() async throws {
        let word = "test"
        let response = try await sut.fetchDefinition(for: word).first()
        #expect(response?.isEmpty == false)
    }
}
