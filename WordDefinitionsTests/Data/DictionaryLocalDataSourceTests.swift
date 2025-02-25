//
//  DictionaryLocalDataSourceTests.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

@testable import WordDefinitions
import Testing
import Combine
import CoreData

struct DictionaryLocalDataSourceTests {
    private var sut: DictionaryLocalDataSourceImpl!
    private var mockContext: NSManagedObjectContext!
    
    init() {
        let container = NSPersistentContainer(name: "TestModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, _ in }
        mockContext = container.viewContext
        
        sut = DictionaryLocalDataSourceImpl(context: mockContext)
    }
    
    @Test func testSaveAndFetchDefinition() async throws {
        let word = "test"
        let definitions = [WordDefinition(word: word, phonetic: "tɛst", sourceUrls: [], license: License(name: "", url: ""), phonetics: [], meanings: [])]

        try sut.saveDefinitions(definitions)
        
        let expectation = #expect(value: try await sut.fetchDefinition(for: word).first()?.word == word)
        try await expectation.fulfill()
    }
}
