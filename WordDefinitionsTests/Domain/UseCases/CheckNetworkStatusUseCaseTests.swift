//
//  CheckNetworkStatusUseCaseTests.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import XCTest
import Combine
@testable import WordDefinitions

class CheckNetworkStatusUseCaseTests: XCTestCase {
    private var sut: CheckNetworkStatusUseCaseImplement!
    private var mockRepository: MockDictionaryRepository!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockRepository = MockDictionaryRepository()
        sut = CheckNetworkStatusUseCaseImplement(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        sut = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testExecute_ReturnsNetworkStatus() {

        mockRepository.isConnected = true

        let expectation = expectation(description: "Should return network status")

        sut.execute()
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                XCTAssertEqual(result, true)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }
}

