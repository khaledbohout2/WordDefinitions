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

    @NSManaged public var antonyms: String?
    @NSManaged public var definition: String?
    @NSManaged public var example: String?
    @NSManaged public var id: UUID?
    @NSManaged public var synonyms: NSObject?

}
