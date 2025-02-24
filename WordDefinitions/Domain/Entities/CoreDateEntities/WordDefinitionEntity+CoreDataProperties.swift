//
//  WordDefinitionEntity+CoreDataProperties.swift
//  
//
//  Created by Khaled-Circle on 24/02/2025.
//
//

import Foundation
import CoreData


extension WordDefinitionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordDefinitionEntity> {
        return NSFetchRequest<WordDefinitionEntity>(entityName: "WordDefinitionEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var phonetic: String?
    @NSManaged public var sourceUrls: NSObject?
    @NSManaged public var word: String?
    @NSManaged public var license: LicenseEntity?
    @NSManaged public var meanings: NSSet?
    @NSManaged public var phonetics: NSSet?

}

// MARK: Generated accessors for meanings
extension WordDefinitionEntity {

    @objc(addMeaningsObject:)
    @NSManaged public func addToMeanings(_ value: MeaningEntity)

    @objc(removeMeaningsObject:)
    @NSManaged public func removeFromMeanings(_ value: MeaningEntity)

    @objc(addMeanings:)
    @NSManaged public func addToMeanings(_ values: NSSet)

    @objc(removeMeanings:)
    @NSManaged public func removeFromMeanings(_ values: NSSet)

}

// MARK: Generated accessors for phonetics
extension WordDefinitionEntity {

    @objc(addPhoneticsObject:)
    @NSManaged public func addToPhonetics(_ value: PhoneticEntity)

    @objc(removePhoneticsObject:)
    @NSManaged public func removeFromPhonetics(_ value: PhoneticEntity)

    @objc(addPhonetics:)
    @NSManaged public func addToPhonetics(_ values: NSSet)

    @objc(removePhonetics:)
    @NSManaged public func removeFromPhonetics(_ values: NSSet)

}
