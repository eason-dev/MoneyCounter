//
//  DenominationRow.swift
//  MoneyCounter
//
//  Created by Eason on 1/4/25.
//

import SwiftUI

/// A row component displaying a single denomination with count controls
struct DenominationRow: View {
    @Binding var denomination: Denomination
    @FocusState var focusedFieldValue: Int?
    
    /// Formatter for the count text field
    private let countFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimum = 0
        formatter.maximum = 9999
        return formatter
    }()

    var body: some View {
        HStack(spacing: 12) {
            // Denomination name
            Text(denomination.displayName)
                .font(.headline)
                .frame(width: 70, alignment: .leading)
            
            Spacer()
            
            // Count controls
            HStack(spacing: 8) {
                // Decrease button
                Button(action: decrementCount) {
                    Image(systemName: "minus")
                        .frame(width: 10, height: 10)
                        .padding(4)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .controlSize(.small)
                .disabled(denomination.count == 0)
                
                // Count input field
                TextField("0", value: Binding(
                    get: { denomination.count },
                    set: { newValue in
                        denomination.count = max(0, newValue)
                    }
                ), formatter: countFormatter)
                    .keyboardType(.numberPad)
                    .frame(width: 60)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .focused($focusedFieldValue, equals: denomination.value)
                
                // Increase button
                Button(action: incrementCount) {
                    Image(systemName: "plus")
                        .frame(width: 10, height: 10)
                        .padding(4)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .controlSize(.small)
            }
            
            Spacer()
            
            // Total amount
            Text(denomination.formattedTotal)
                .font(.body.monospacedDigit())
                .frame(width: 80, alignment: .trailing)
                .foregroundStyle(denomination.count > 0 ? .primary : .secondary)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Actions
    
    private func incrementCount() {
        denomination.count += 1
    }
    
    private func decrementCount() {
        denomination.count = max(0, denomination.count - 1)
    }
}

#Preview {
    @Previewable @State var denomination = Denomination(value: 10000)
    @Previewable @FocusState var focusedFieldValue: Int?

    DenominationRow(
        denomination: $denomination,
        focusedFieldValue: _focusedFieldValue
    )
}
