//
//  PersistenceError.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import Foundation

enum PersistenceError: Error {
    case saveError(Error)
    case fetchError(Error)
    case deleteError(Error)
}

