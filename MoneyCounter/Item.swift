//
//  Item.swift
//  MoneyCounter
//
//  Created by Eason on 12/29/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
