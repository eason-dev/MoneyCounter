//
//  Currency.swift
//  MoneyCounter
//
//  Created by Eason on 1/15/25.
//

import Foundation

/// Currency-related constants and utilities
enum Currency {
    /// Standard currency denominations in cents (sorted by value, descending)
    static let standardDenominations: [Int] = [
        10000,  // $100.00
        5000,   // $50.00
        2000,   // $20.00
        1000,   // $10.00
        500,    // $5.00
        200,    // $2.00 (Toonie)
        100,    // $1.00 (Loonie)
        25,     // $0.25
        10,     // $0.10
        5       // $0.05
    ]
    
    /// Currency formatter for consistent display (Canadian dollars)
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_CA") // Canadian English locale
        formatter.currencyCode = "CAD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    /// Converts cents to dollars
    static func centsToDollars(_ cents: Int) -> Decimal {
        Decimal(cents) / 100
    }
    
    /// Formats cents as currency string
    static func format(cents: Int) -> String {
        let dollars = NSDecimalNumber(decimal: centsToDollars(cents))
        return formatter.string(from: dollars) ?? "$0.00"
    }
}