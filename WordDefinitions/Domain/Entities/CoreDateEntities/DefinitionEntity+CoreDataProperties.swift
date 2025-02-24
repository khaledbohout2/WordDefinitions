//
//  DefinitionEntity+CoreDataProperties.swift
//  
//
//  Created by Khaled-Circle on 24/02/2025.
//
//

import Foundation
import CoreData


extension DefinitionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DefinitionEntity> {
        return NSFetchRequest<DefinitionEntity>(entityName: "DefinitionEntity")
    }

    @NSManaged public var antonyms: NSObject?
    @NSManaged public var definition: String?
    @NSManaged public var example: String?
    @NSManaged public var id: UUID?
    @NSManaged public var synonyms: NSObject?

}

extension DefinitionEntity {
    func toDefinition() -> Definition {
        return Definition(
            definition: definition ?? "",
            synonyms: synonyms as? [String] ?? [],
            antonyms: antonyms as? [String] ?? [],
            example: example ?? ""
        )
    }
}
