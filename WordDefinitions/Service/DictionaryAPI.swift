//
//  DictionaryAPI.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import Moya

enum DictionaryAPI {
    case search(word: String)
}

extension DictionaryAPI: TargetType {
    var baseURL: URL { URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en")! }
    
    var path: String {
        switch self {
        case .search(let word):
            return "/\(word)"
        }
    }
    
    var method: Moya.Method { .get }
    var task: Task { .requestPlain }
    var headers: [String: String]? { nil }
}
