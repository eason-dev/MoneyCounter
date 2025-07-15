//
//  HistoryView.swift
//  MoneyCounter
//
//  Created by Eason on 1/2/25.
//

import SwiftUI
import SwiftData

/// View displaying the history of saved money counts
struct HistoryView: View {
    // MARK: - Properties
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\History.date, order: .reverse)]) 
    private var histories: [History]
    
    @State private var showingDeleteError = false
    @State private var deleteErrorMessage = ""
    
    /// Date formatter for history entries
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Group {
                if histories.isEmpty {
                    emptyStateView
                } else {
                    historyList
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .disabled(histories.isEmpty)
                }
            }
            .alert("Delete Error", isPresented: $showingDeleteError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(deleteErrorMessage)
            }
        }
    }
    
    // MARK: - View Components
    
    private var historyList: some View {
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
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            "No History",
            systemImage: "clock.badge.xmark",
            description: Text("Your counting history will appear here")
        )
    }
    
    // MARK: - Actions
    
    private func deleteHistories(_ indexSet: IndexSet) {
        // Collect items to delete
        let historiesToDelete = indexSet.map { histories[$0] }
        
        // Delete from context
        for history in historiesToDelete {
            modelContext.delete(history)
        }
        
        // Save changes
        do {
            try modelContext.save()
        } catch {
            // Revert changes on error
            modelContext.rollback()
            
            // Show error to user
            deleteErrorMessage = "Failed to delete history: \(error.localizedDescription)"
            showingDeleteError = true
        }
    }
}

#if DEBUG
#Preview {
    let preview = Preview()
    preview.addExamples(History.sampleHistories)

    return HistoryView()
        .modelContainer(preview.modelContainer)
}
#endif
