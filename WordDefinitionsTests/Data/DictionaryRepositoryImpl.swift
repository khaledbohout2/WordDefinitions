//
//  DictionaryRepositoryImpl.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import XCTest
import Combine
@testable import WordDefinitions
import CoreData

class DictionaryRepositoryTests: XCTestCase {
    private var sut: DictionaryRepositoryImpl!
    private var localDataSource: MockDictionaryLocalDataSource!
    private var remoteDataSource: MockDictionaryRemoteDataSource!
    private var networkMonitor: NetworkMonitorProtocol!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        localDataSource = MockDictionaryLocalDataSource()
        remoteDataSource = MockDictionaryRemoteDataSource()
        networkMonitor = MockNetworkMonitor()

        sut = DictionaryRepositoryImpl(local: localDataSource, remote: remoteDataSource, networkMonitor: networkMonitor)
    }

    override func tearDown() {
        sut = nil
        localDataSource = nil
        remoteDataSource = nil
        networkMonitor = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testGetDefinition_FromCache() {
        let word = "test"
        
        let mockEntity = WordDefinitionEntity(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        mockEntity.word = word
        mockEntity.phonetic = ""
        mockEntity.license = LicenseEntity(context: mockEntity.managedObjectContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        mockEntity.sourceUrls = [] as NSObject
        
        localDataSource.mockDefinitions = [mockEntity]

        let expectation = expectation(description: "Fetch word from cache")

        sut.getDefinition(for: word)
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                XCTAssertEqual(result.first?.word, word)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }

}

