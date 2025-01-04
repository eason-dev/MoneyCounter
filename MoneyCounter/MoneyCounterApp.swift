//
//  MoneyCounterApp.swift
//  MoneyCounter
//
//  Created by Eason on 12/29/24.
//

import SwiftUI
import SwiftData

@main
struct MoneyCounterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: History.self, isAutosaveEnabled: true)
    }
}
