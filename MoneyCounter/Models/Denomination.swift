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
    var value: Int
    var count: Int
    
    var name: String {
        return (Double(value) / 100).formatted()
    }
    
    var subtotal: Double {
        return Double(count * value) / 100
    }
    
    init(value: Int) {
        self.id = UUID()
        self.value = value
        self.count = 0
    }
}
