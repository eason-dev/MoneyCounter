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
    @State private var history: History = History()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(
                        $history.denominations.sorted { $0.wrappedValue.value > $1.wrappedValue.value }
                    ) { $denomination in
                        DenominationRow(denomination: $denomination)
                    }
                } header: {
                    Text(history.date
                        .formatted(date: .numeric, time: .shortened))
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
            .onAppear {
                if histories.isEmpty {
                    let newHistory = History()
                    modelContext.insert(newHistory)
                    history = newHistory
                } else {
                    history = histories.first ?? History()
                }
            }
            .toolbar {
                Button("New") {
                    saveHistory()
                }
            }
        }
    }

    private func saveHistory() {
        let newHistory = History()
        modelContext.insert(newHistory)
        history = newHistory
    }
}

#Preview {
    let preview = Preview()
    preview.addExamples(History.sampleHistories)
    
    return CounterView()
        .modelContainer(preview.modelContainer)
}
