//
//  History.swift
//  MoneyCounter
//
//  Created by Eason on 1/2/25.
//

import Foundation
import SwiftData

@Model
class History: Identifiable {
    var id: UUID
    var date: Date
    @Relationship(deleteRule: .cascade) var denominations: [Denomination]
    
    var total: Double {
        return denominations.reduce(0.0) { $0 + $1.subtotal }
    }
    
    init() {
        self.id = UUID()
        self.date = .now
        self.denominations = [
            Denomination(name: "100", value: 10000),
            Denomination(name: "50", value: 5000),
            Denomination(name: "20", value: 2000),
            Denomination(name: "10", value: 1000),
            Denomination(name: "5", value: 500),
            Denomination(name: "2", value: 200),
            Denomination(name: "1", value: 100),
            Denomination(name: "0.25", value: 25),
            Denomination(name: "0.1", value: 10),
            Denomination(name: "0.05", value: 5),
        ]
    }
}
