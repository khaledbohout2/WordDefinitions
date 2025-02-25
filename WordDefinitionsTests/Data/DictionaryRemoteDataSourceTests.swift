//
//  DictionaryRemoteDataSourceTests.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import XCTest
import Combine
import Moya
@testable import WordDefinitions

class DictionaryRemoteDataSourceTests: XCTestCase {
    private var sut: DictionaryRemoteDataSourceImpl!
    private var provider: MoyaProvider<DictionaryAPI>!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        provider = MoyaProvider<DictionaryAPI>(stubClosure: MoyaProvider.immediatelyStub)
        sut = DictionaryRemoteDataSourceImpl(provider: provider)
    }

    override func tearDown() {
        sut = nil
        provider = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchDefinition_Success() {
        let word = "test"
        let expectation = expectation(description: "Fetch definition success")

        sut.fetchDefinition(for: word)
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                XCTAssertFalse(response.isEmpty, "Response should not be empty")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }
}

