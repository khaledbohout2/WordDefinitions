//
//  MeaningEntity+CoreDataProperties.swift
//  
//
//  Created by Khaled-Circle on 24/02/2025.
//
//

import Foundation
import CoreData


extension MeaningEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeaningEntity> {
        return NSFetchRequest<MeaningEntity>(entityName: "MeaningEntity")
    }

    @NSManaged public var antonyms: NSObject?
    @NSManaged public var id: UUID?
    @NSManaged public var partOfSpeech: String?
    @NSManaged public var synonyms: NSObject?
    @NSManaged public var definitions: NSSet?

}

// MARK: Generated accessors for definitions
extension MeaningEntity {

    @objc(addDefinitionsObject:)
    @NSManaged public func addToDefinitions(_ value: DefinitionEntity)

    @objc(removeDefinitionsObject:)
    @NSManaged public func removeFromDefinitions(_ value: DefinitionEntity)

    @objc(addDefinitions:)
    @NSManaged public func addToDefinitions(_ values: NSSet)

    @objc(removeDefinitions:)
    @NSManaged public func removeFromDefinitions(_ values: NSSet)

}

extension MeaningEntity {
    func toMeaning() -> Meaning {
        return Meaning(
            partOfSpeech: partOfSpeech ?? "",
            definitions: (definitions as? Set<DefinitionEntity>)?.map { $0.toDefinition() } ?? [],
            synonyms: synonyms as? [String] ?? [],
            antonyms: antonyms as? [String] ?? []
        )
    }
}
