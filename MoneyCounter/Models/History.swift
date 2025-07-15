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
    
    /// Total value formatted as currency
    var formattedTotal: String {
        Currency.format(cents: Int(total * 100))
    }
    
    /// Sorted denominations from highest to lowest value
    var sortedDenominations: [Denomination] {
        denominations.sorted { $0.value > $1.value }
    }
    
    init() {
        self.id = UUID()
        self.date = .now
        self.denominations = [
            Denomination(value: 10000),
            Denomination(value: 5000),
            Denomination(value: 2000),
            Denomination(value: 1000),
            Denomination(value: 500),
            Denomination(value: 200),
            Denomination(value: 100),
            Denomination(value: 25),
            Denomination(value: 10),
            Denomination(value: 5),
        ].sorted { $0.value > $1.value }
    }
}
