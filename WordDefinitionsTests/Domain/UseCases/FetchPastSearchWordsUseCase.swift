//
//  FetchPastSearchWordsUseCase.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import XCTest
import Combine
@testable import WordDefinitions

class FetchPastSearchWordsUseCaseTests: XCTestCase {
    private var sut: FetchPastSearchWordsUseCaseImplement!
    private var mockLocalDataSource: MockDictionaryLocalDataSource!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockLocalDataSource = MockDictionaryLocalDataSource()
        sut = FetchPastSearchWordsUseCaseImplement(localDataSource: mockLocalDataSource)
    }

    override func tearDown() {
        mockLocalDataSource = nil
        sut = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testExecute_ReturnsPastSearchWords() {

        mockLocalDataSource.mockRecentSearches = ["hello", "world"]

        let expectation = expectation(description: "Should return past search words")

        sut.execute()
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                XCTAssertEqual(result, ["hello", "world"])
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }
}

