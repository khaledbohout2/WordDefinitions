//
//  PhoneticEntity+CoreDataProperties.swift
//  
//
//  Created by Khaled-Circle on 24/02/2025.
//
//

import Foundation
import CoreData


extension PhoneticEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneticEntity> {
        return NSFetchRequest<PhoneticEntity>(entityName: "PhoneticEntity")
    }

    @NSManaged public var audio: String?
    @NSManaged public var id: UUID?
    @NSManaged public var sourceURL: String?
    @NSManaged public var text: String?
    @NSManaged public var license: LicenseEntity?

}

extension PhoneticEntity {
    func toPhonetic() -> Phonetic {
        return Phonetic(
            text: text ?? "",
            audio: audio ?? "",
            sourceURL: sourceURL ?? "",
            license: license?.toLicense() ?? License(name: "", url: "")
        )
    }
}
