//
//  CounterView.swift
//  MoneyCounter
//
//  Created by Eason on 1/2/25.
//

import SwiftUI
import SwiftData

/// Main counting interface for the money counter
struct CounterView: View {
    // MARK: - Properties
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\History.date, order: .reverse)]) 
    private var histories: [History]
    
    @State private var currentHistory: History = History()
    @State private var hasLoadedInitialHistory = false
    @FocusState private var focusedFieldValue: Int?
    
    /// Date formatter for the section header
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                denominationSection
            }
            .navigationTitle("Money Counter")
            .onAppear(perform: loadInitialHistory)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    saveButton
                }
                
                ToolbarItem(placement: .keyboard) {
                    keyboardToolbar
                }
            }
        }
    }
    
    // MARK: - View Components
    
    private var denominationSection: some View {
        Section {
            ForEach($currentHistory.denominations.sorted { $0.wrappedValue.value > $1.wrappedValue.value }) { $denomination in
                DenominationRow(
                    denomination: $denomination,
                    focusedFieldValue: _focusedFieldValue
                )
            }
        } header: {
            Text(currentHistory.date, formatter: dateFormatter)
        } footer: {
            HStack {
                Spacer()
                Text("Total: \(currentHistory.formattedTotal)")
                    .font(.headline)
            }
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            saveNewHistory()
        }
    }
    
    private var keyboardToolbar: some View {
        HStack {
            Button(action: navigateToPreviousField) {
                Image(systemName: "chevron.up")
            }
            .disabled(!canNavigateUp)
            
            Button(action: navigateToNextField) {
                Image(systemName: "chevron.down")
            }
            .disabled(!canNavigateDown)
            
            Spacer()
            
            Button("Done") {
                focusedFieldValue = nil
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var sortedDenominations: [Denomination] {
        currentHistory.sortedDenominations
    }
    
    private var currentFieldIndex: Int? {
        guard let focusedValue = focusedFieldValue else { return nil }
        return sortedDenominations.firstIndex { $0.value == focusedValue }
    }
    
    private var canNavigateUp: Bool {
        guard let index = currentFieldIndex else { return false }
        return index > 0
    }
    
    private var canNavigateDown: Bool {
        guard let index = currentFieldIndex else { return false }
        return index < sortedDenominations.count - 1
    }
    
    // MARK: - Actions
    
    private func loadInitialHistory() {
        guard !hasLoadedInitialHistory else { return }
        hasLoadedInitialHistory = true
        
        if let mostRecent = histories.first {
            currentHistory = mostRecent
        } else {
            // Create and save initial history
            let newHistory = History()
            modelContext.insert(newHistory)
            currentHistory = newHistory
            
            // Save context
            do {
                try modelContext.save()
            } catch {
                print("Failed to save initial history: \(error)")
            }
        }
    }
    
    private func saveNewHistory() {
        let newHistory = History()
        modelContext.insert(newHistory)
        
        do {
            try modelContext.save()
            currentHistory = newHistory
        } catch {
            print("Failed to save new history: \(error)")
        }
    }
    
    private func navigateToPreviousField() {
        guard let index = currentFieldIndex, index > 0 else { return }
        focusedFieldValue = sortedDenominations[index - 1].value
    }
    
    private func navigateToNextField() {
        guard let index = currentFieldIndex, index < sortedDenominations.count - 1 else { return }
        focusedFieldValue = sortedDenominations[index + 1].value
    }
}

#if DEBUG
#Preview {
    let preview = Preview()
    preview.addExamples(History.sampleHistories)
    
    return CounterView()
        .modelContainer(preview.modelContainer)
}
#endif
