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
        NavigationStack {
            List {
                Section {
                    ForEach(history.denominations) { denomination in
                        DenominationRow(denomination: denomination)
                    }
                } header: {
                    Text(history.date
                        .formatted(date: .numeric, time: .omitted))
                } footer: {
                    HStack {
                        Spacer()
                        Text("Total: \(String(format: "$%.2f", history.total))")
                            .font(.headline)

                    }
                }
            }
            .navigationTitle("Coin Counter")
            .listStyle(.grouped)
        }
    }
}

#Preview {
    let preview = Preview()
    preview.addExamples(History.sampleHistories)
    
    return CounterView()
        .modelContainer(preview.modelContainer)
}
