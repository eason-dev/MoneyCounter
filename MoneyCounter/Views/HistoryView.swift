//
//  HistoryView.swift
//  MoneyCounter
//
//  Created by Eason on 1/2/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\History.date, order: .reverse)]) var histories: [History]

    var body: some View {
        NavigationStack {
            List {
                ForEach(histories) { history in
                    HStack {
                        Text(
                            history.date
                                .formatted(date: .numeric, time: .shortened)
                        )
                        Spacer()
                        Text(
                            String(format: "$%.2f", history.total)
                        )
                    }
                }
                .onDelete(perform: deleteHistories)
            }
            .navigationTitle("History")
            .toolbar {
                EditButton()
            }
        }
    }
    
    func deleteHistories(_ indexSet: IndexSet) {
        for index in indexSet {
            let history = histories[index]
            modelContext.delete(history)
        }
        do {
            try modelContext.save()
        } catch {}
    }
}

#Preview {
    let preview = Preview()
    preview.addExamples(History.sampleHistories)

    return HistoryView()
        .modelContainer(preview.modelContainer)
}
