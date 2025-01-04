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
        List {
            ForEach(histories) { history in
                NavigationLink(value: history.id) {
                    VStack(alignment: .leading) {
                       
                        Text(
                            history.date
                                .formatted(date: .numeric, time: .omitted)
                        )
                    }
                }
            }
//            .onDelete(perform: deleteDestinations)
        }
    }
}

#Preview {
    let preview = Preview()
    preview.addExamples(History.sampleHistories)

    return HistoryView()
        .modelContainer(preview.modelContainer)
}
