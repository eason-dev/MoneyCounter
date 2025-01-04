//
//  Preview.swift
//  MoneyCounter
//
//  Created by Eason on 1/4/25.
//

import Foundation
import SwiftData

struct Preview {
    let modelContainer: ModelContainer

    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            modelContainer = try ModelContainer(for: History.self, configurations: config)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    func addExamples(_ examples: [History]) {
        Task { @MainActor in
            examples.forEach { example in
                modelContainer.mainContext.insert(example)
            }
        }
        
    }
    
}
