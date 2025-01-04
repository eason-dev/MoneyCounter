//
//  Denomination.swift
//  MoneyCounter
//
//  Created by Eason on 1/2/25.
//

import Foundation
import SwiftData

@Model
class Denomination: Identifiable {
    var id: UUID
    var name: String
    var value: Int
    var count: Int
    
    var subtotal: Double {
        return Double(count * value) / 100
    }
    
    init(name: String, value: Int) {
        self.id = UUID()
        self.name = name
        self.value = value
        self.count = 0
    }
}
