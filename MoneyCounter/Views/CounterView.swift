//
//  CounterView.swift
//  MoneyCounter
//
//  Created by Eason on 1/2/25.
//

import SwiftUI

struct CounterView: View {
    @State private var counts: [UUID: Int] = [:]
    
    private func subtotal(for denomination: Denomination) -> Double {
        let count = counts[denomination.id] ?? 0
        return Double(count) * (Double(denomination.value) / 100)
    }
    
    private var total: Double {
        denominations.reduce(0.0) { $0 + subtotal(for: $1) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    List(denominations) { denomination in
                        HStack {
                            Text(denomination.name)
                                .font(.headline)
                                .frame(width: 50, alignment: .leading)
                            
                            Spacer()
                            
                            Button {
                                if let currentCount = counts[denomination.id], currentCount > 0 {
                                    counts[denomination.id] = currentCount - 1
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .frame(width: 10, height: 10)
                                    .padding(2)
                                
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.circle)
                            .controlSize(.small)
                            
                            TextField("0", text: Binding(
                                get: { String(counts[denomination.id] ?? 0) },
                                set: { counts[denomination.id] = Int($0) ?? 0 }
                            ))
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .border(.secondary)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            
                            Button {
                                counts[denomination.id] = (counts[denomination.id] ?? 0) + 1
                            } label: {
                                Image(systemName: "plus")
                                    .frame(width: 10, height: 10)
                                    .padding(3)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.circle)
                            .controlSize(.small)
                            
                            Spacer()
                            
                            Text(String(format: "$%.2f", subtotal(for: denomination)))
                                .frame(width: 80, alignment: .trailing)
                        }
                    }
                    .listStyle(.grouped)
                }
                
                HStack {
                    Spacer()
                    Text("Total: ")
                        .font(.headline)
                    Text(String(format: "$%.2f", total))
                        .font(.headline)
                        .bold()
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Coin Counter")
        }
    }
}

#Preview {
    CounterView()
}
