//
//  DictionaryRepositoryImpl.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

@testable import WordDefinitions
import Testing
import Combine

struct DictionaryRepositoryTests {
    private var sut: DictionaryRepositoryImpl!
    private var localDataSource: MockDictionaryLocalDataSource!
    private var remoteDataSource: MockDictionaryRemoteDataSource!
    private var networkMonitor: MockNetworkMonitor!
    
    init() {
        localDataSource = MockDictionaryLocalDataSource()
        remoteDataSource = MockDictionaryRemoteDataSource()
        networkMonitor = MockNetworkMonitor()
        
        sut = DictionaryRepositoryImpl(local: localDataSource, remote: remoteDataSource, networkMonitor: networkMonitor)
    }
    
    @Test func testGetDefinition_FromCache() async throws {
        let word = "test"
        localDataSource.mockDefinitions = [WordDefinition(word: word, phonetic: "", sourceUrls: [], license: License(name: "", url: ""), phonetics: [], meanings: [])]
        
        let result = try await sut.getDefinition(for: word).first()
        #expect(result?.first?.word == word)
    }
}
