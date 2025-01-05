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
    @FocusState private var focusedFieldValue: Int?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(
                        $history.denominations.sorted { $0.wrappedValue.value > $1.wrappedValue.value }
                    ) { $denomination in
                        DenominationRow(
                            denomination: $denomination,
                            focusedFieldValue: _focusedFieldValue
                        )
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
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button {
                            if let currentValue = focusedFieldValue {
                                let sortedDenominations = history.denominations.sorted { $0.value > $1.value }
                                let currentDenominationIndex = sortedDenominations.firstIndex { $0.value == currentValue } ?? 0
                                let previousDenominationIndex = currentDenominationIndex > 0 ? currentDenominationIndex - 1 : nil
                                if previousDenominationIndex != nil {
                                    focusedFieldValue = sortedDenominations[previousDenominationIndex!].value
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        Button {
                            if let currentValue = focusedFieldValue {
                                let sortedDenominations = history.denominations.sorted { $0.value > $1.value }
                                let currentDenominationIndex = sortedDenominations.firstIndex { $0.value == currentValue } ?? 0
                                let nextDenominationIndex = currentDenominationIndex < sortedDenominations.count - 1 ? currentDenominationIndex + 1 : nil
                                if nextDenominationIndex != nil {
                                    focusedFieldValue = sortedDenominations[nextDenominationIndex!].value
                                }
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                        Spacer()
                        Button("Done") {
                            focusedFieldValue = nil
                        }
                    }
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
