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
    @State private var newHistory: History?

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
            .navigationTitle("Money Counter")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: createNewHistory) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .disabled(histories.isEmpty)
                }
            }
            .navigationDestination(item: $newHistory) { history in
                EditCounterView(history: history)
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
                NavigationLink(destination: EditCounterView(history: history)) {
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
    
    private func createNewHistory() {
        let history = History()
        modelContext.insert(history)
        
        do {
            try modelContext.save()
            
            // Delay navigation to ensure the history is properly saved
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                newHistory = history
            }
        } catch {
            print("Failed to create new history: \(error)")
        }
    }
    
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
