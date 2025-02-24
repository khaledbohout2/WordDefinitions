//
//  LicenseEntity+CoreDataProperties.swift
//  
//
//  Created by Khaled-Circle on 24/02/2025.
//
//

import Foundation
import CoreData


extension LicenseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LicenseEntity> {
        return NSFetchRequest<LicenseEntity>(entityName: "LicenseEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var url: String?

}

extension LicenseEntity {
    func toLicense() -> License {
        return License(
            name: name ?? "",
            url: url ?? ""
        )
    }
}
