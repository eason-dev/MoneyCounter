//
//  CounterView.swift
//  MoneyCounter
//
//  Created by Eason on 1/2/25.
//

import SwiftUI
import SwiftData

struct CounterView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\History.date, order: .reverse)]) var histories: [History]
    var history: History { histories.first ?? History() }

    var body: some View {
        NavigationView {
            VStack {
                Text(
                    history.date
                        .formatted(date: .numeric, time: .omitted)
                    )

                Group {
                    List(history.denominations) { denomination in
                        HStack {
                            Text(denomination.name)
                                .font(.headline)
                                .frame(width: 50, alignment: .leading)
                            
                            Spacer()
                            
                            Button {
                                if denomination.count > 0 {
                                    denomination.count = denomination.count - 1
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
                                get: { String(denomination.count) },
                                set: { denomination.count = Int($0) ?? 0 }
                            ))
                            .keyboardType(.numberPad)
                            .frame(width: 80)
                            .border(.secondary)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                            
                            Button {
                                denomination.count += 1
                            } label: {
                                Image(systemName: "plus")
                                    .frame(width: 10, height: 10)
                                    .padding(3)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.circle)
                            .controlSize(.small)
                            
                            Spacer()
                            
                            Text(String(format: "$%.2f", denomination.subtotal))
                                .frame(width: 80, alignment: .trailing)
                        }
                    }
                    .listStyle(.grouped)
                }
                
                HStack {
                    Spacer()
                    Text("Total: ")
                        .font(.headline)
                    Text(String(format: "$%.2f", history.total))
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
    let preview = Preview()
    preview.addExamples(History.sampleHistories)
    
    return CounterView()
        .modelContainer(preview.modelContainer)
}
