//
//  WordDefinitionsApp.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import SwiftUI

@main
struct DictionaryApp: App {
    @StateObject private var coordinator = DictionaryCoordinator()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.start()
                    .environmentObject(coordinator)
            }
        }
    }
}
