//
//  DictionaryLocalDataSourceTests.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import XCTest
import Combine
import CoreData
@testable import WordDefinitions

class DictionaryLocalDataSourceTests: XCTestCase {
    private var sut: DictionaryLocalDataSourceImpl!
    private var mockContext: NSManagedObjectContext!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        let container = NSPersistentContainer(name: "TestModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        let expectation = expectation(description: "Persistent store loaded")
        container.loadPersistentStores { _, error in
            XCTAssertNil(error, "Failed to load persistent store: \(error?.localizedDescription ?? "")")
            self.mockContext = container.viewContext
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0)

        sut = DictionaryLocalDataSourceImpl(context: mockContext)
    }

    override func tearDown() {
        sut = nil
        mockContext = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testSaveAndFetchDefinition() throws {
        let word = "test"
        let definitions = [
            WordDefinition(
                word: word,
                phonetic: "tɛst",
                phonetics: [],
                meanings: [] ,
                license: License(name: "", url: ""),
                sourceUrls: []
            )
        ]

        try sut.saveDefinitions(definitions)

        let expectation = expectation(description: "Fetch definitions")

        sut.fetchDefinition(for: word)
            .sink(receiveCompletion: { _ in }, receiveValue: { result in
                XCTAssertEqual(result.first?.word, word, "Fetched word definition does not match")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }
}

