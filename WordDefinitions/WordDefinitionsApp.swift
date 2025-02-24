//
//  WordDefinitionsApp.swift
//  WordDefinitions
//
//  Created by Khaled-Circle on 24/02/2025.
//

import SwiftUI

@main
struct WordDefinitionsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
