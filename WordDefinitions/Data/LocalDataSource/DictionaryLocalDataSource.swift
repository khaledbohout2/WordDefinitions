//
//  DictionaryLocalDataSource.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import Combine
import CoreData

protocol DictionaryLocalDataSource {
    func fetchDefinition(for word: String) -> AnyPublisher<[WordDefinitionEntity], Error>
    func saveDefinitions(_ definitions: [WordDefinition]) throws
    func fetchRecentSearches() -> AnyPublisher<[String], Error>
}

class DictionaryLocalDataSourceImpl: DictionaryLocalDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchDefinition(for word: String) -> AnyPublisher<[WordDefinitionEntity], Error> {
        return Future { promise in
            self.context.perform {
                let request: NSFetchRequest<WordDefinitionEntity> = WordDefinitionEntity.fetchRequest()
                request.predicate = NSPredicate(format: "word ==[c] %@", word as NSString)
                
                do {
                    let results = try self.context.fetch(request)
                    promise(.success(results))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    func saveDefinitions(_ definitions: [WordDefinition]) throws {
        do {
            try context.performAndWait {
                let words = definitions.map { $0.word.lowercased() }
                let request: NSFetchRequest<WordDefinitionEntity> = WordDefinitionEntity.fetchRequest()
                request.predicate = NSPredicate(format: "word IN %@", words)

                let existingEntities = try context.fetch(request)
                var entityMap = Dictionary(uniqueKeysWithValues: existingEntities.map { ($0.word?.lowercased() ?? "", $0) })

                var didModify = false

                for definition in definitions {
                    let normalizedWord = definition.word.lowercased()

                    let entity: WordDefinitionEntity
                    if let existingEntity = entityMap[normalizedWord] {
                        entity = existingEntity
                    } else {
                        entity = WordDefinitionEntity(context: context)
                        entity.id = UUID()
                        entity.word = definition.word
                        entityMap[normalizedWord] = entity
                    }

                    entity.phonetic = definition.phonetic
                    entity.sourceUrls = definition.sourceUrls as NSObject
                    entity.license = mapLicense(definition.license)
                    entity.phonetics = NSSet(array: definition.phonetics.map(mapPhonetic))
                    entity.meanings = NSSet(array: definition.meanings.map(mapMeaning))
                    
                    didModify = true
                }
                if didModify {
                    try context.save()
                }
            }
        } catch {
            throw PersistenceError.saveError(error)
        }
    }

    func fetchRecentSearches() -> AnyPublisher<[String], Error> {
        return Future { promise in
            self.context.perform {
                let request: NSFetchRequest<WordDefinitionEntity> = WordDefinitionEntity.fetchRequest()
                request.sortDescriptors = [
                    NSSortDescriptor(key: "word", ascending: true),
                    NSSortDescriptor(key: "phonetic", ascending: false)
                ]
                request.fetchLimit = 10

                do {
                    let results = try self.context.fetch(request)
                    let words = results.map { $0.word ?? "" }
                    promise(.success(words))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    private func mapLicense(_ license: License) -> LicenseEntity {
        let entity = LicenseEntity(context: context)
        entity.id = UUID()
        entity.name = license.name
        entity.url = license.url
        return entity
    }
    
    private func mapPhonetic(_ phonetic: Phonetic) -> PhoneticEntity {
        let entity = PhoneticEntity(context: context)
        entity.id = UUID()
        entity.text = phonetic.text
        entity.audio = phonetic.audio
        entity.sourceURL = phonetic.sourceURL
        entity.license = phonetic.license.map(mapLicense)
        return entity
    }

    private func mapMeaning(_ meaning: Meaning) -> MeaningEntity {
        let entity = MeaningEntity(context: context)
        entity.id = UUID()
        entity.partOfSpeech = meaning.partOfSpeech
        entity.synonyms = meaning.synonyms as NSObject
        entity.antonyms = meaning.antonyms as NSObject
        entity.definitions = NSSet(array: meaning.definitions.map(mapDefinition))
        return entity
    }

    private func mapDefinition(_ definition: Definition) -> DefinitionEntity {
        let entity = DefinitionEntity(context: context)
        entity.id = UUID()
        entity.definition = definition.definition
        entity.example = definition.example
        entity.synonyms = definition.synonyms as NSObject
        entity.antonyms = definition.antonyms as NSObject
        return entity
    }
}
