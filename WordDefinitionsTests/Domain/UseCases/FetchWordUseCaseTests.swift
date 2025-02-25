//
//  DictionaryRepository.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import XCTest
import Combine
@testable import WordDefinitions

class FetchWordUseCaseTests: XCTestCase {
    private var sut: FetchWordUseCaseImplement!
    private var mockRepository: MockDictionaryRepository!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockRepository = MockDictionaryRepository()
        sut = FetchWordUseCaseImplement(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        sut = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testExecute_ReturnsDefinitions() {
        let word = "test"
        let mockDefinition = WordDefinition(
            word: word,
            phonetic: "",
            phonetics: [],
            meanings: [],
            license: License(name: "", url: ""),
            sourceUrls: []
        )
        mockRepository.mockDefinitions = [mockDefinition]

        let expectation = expectation(description: "Should return definitions")

        sut.execute(word: word)
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                XCTAssertEqual(result.first?.word, word)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }
}
