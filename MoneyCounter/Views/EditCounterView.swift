//
//  EditCounterView.swift
//  MoneyCounter
//
//  Created by Eason on 1/16/25.
//

import SwiftUI
import SwiftData

/// View for editing existing history entries
struct EditCounterView: View {
    // MARK: - Properties
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var history: History
    @State private var showingDatePicker = false
    @FocusState private var focusedFieldValue: Int?
    
    // MARK: - Body
    
    var body: some View {
        List {
            dateSection
            denominationSection
        }
        .navigationTitle("Count Details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            cleanupIfEmpty()
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                keyboardToolbar
            }
        }
    }
    
    // MARK: - View Components
    
    private var dateSection: some View {
        Section {
            HStack {
                Text("Date")
                Spacer()
                Button(action: { showingDatePicker.toggle() }) {
                    Text(history.date.formatted(date: .abbreviated, time: .shortened))
                        .foregroundStyle(.primary)
                }
            }
            
            if showingDatePicker {
                DatePicker(
                    "Edit Date",
                    selection: $history.date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .onChange(of: history.date) { _, _ in
                    autoSave()
                }
            }
        }
    }
    
    private var denominationSection: some View {
        Section {
            ForEach(history.sortedDenominations) { denomination in
                if let index = history.denominations.firstIndex(where: { $0.id == denomination.id }) {
                    DenominationRow(
                        denomination: Binding(
                            get: { history.denominations[index] },
                            set: { newValue in
                                history.denominations[index] = newValue
                                autoSave()
                            }
                        ),
                        focusedFieldValue: _focusedFieldValue
                    )
                }
            }
        } footer: {
            HStack {
                Spacer()
                Text("Total: \(history.formattedTotal)")
                    .font(.headline)
            }
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
        history.sortedDenominations
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
    
    private func autoSave() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to auto-save: \(error)")
        }
    }
    
    private func cleanupIfEmpty() {
        // Delete history if all counts are zero
        if history.total == 0 {
            modelContext.delete(history)
            do {
                try modelContext.save()
            } catch {
                print("Failed to delete empty history: \(error)")
            }
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
    let history = History()
    history.denominations[0].count = 5
    history.denominations[2].count = 3
    preview.addExamples([history])
    
    return NavigationStack {
        EditCounterView(history: history)
    }
    .modelContainer(preview.modelContainer)
}
#endif