//
//  NetworkError.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 25/02/2025.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case requestFailed(Error)
    case decodingFailed(Error)
}
