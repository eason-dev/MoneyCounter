//
//  Denomination.swift
//  MoneyCounter
//
//  Created by Eason on 1/2/25.
//

import Foundation

struct Denomination: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let value: Int
}

let denominations = [
    Denomination(name: "100", image: "dollar", value: 10000),
    Denomination(name: "50", image: "dollar", value: 5000),
    Denomination(name: "20", image: "dollar", value: 2000),
    Denomination(name: "10", image: "dollar", value: 1000),
    Denomination(name: "5", image: "dollar", value: 500),
    Denomination(name: "2", image: "toonie", value: 200),
    Denomination(name: "1", image: "loonie", value: 100),
    Denomination(name: "0.25", image: "quarter", value: 25),
    Denomination(name: "0.1", image: "dime", value: 10),
    Denomination(name: "0.05", image: "nickel", value: 5),
]
