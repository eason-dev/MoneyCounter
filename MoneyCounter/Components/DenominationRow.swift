//
//  DenominationRow.swift
//  MoneyCounter
//
//  Created by Eason on 1/4/25.
//

import SwiftUI

struct DenominationRow: View {
    @Binding var denomination: Denomination
    @FocusState var focusedFieldValue: Int?

    var body: some View {
        HStack {
            Text(denomination.name)
                .font(.headline)
                .frame(width: 50, alignment: .leading)
            
            Spacer()
            
            Button {
                if denomination.count > 0 {
                    denomination.count = denomination.count - 1
                }
            } label: {
                Image(systemName: "minus")
                    .frame(width: 10, height: 10)
                    .padding(2)
                
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.circle)
            .controlSize(.small)
            
            TextField("0", text: Binding(
                get: { String(denomination.count) },
                set: { denomination.count = Int($0) ?? 0 }
            ))
            .keyboardType(.numberPad)
            .frame(width: 80)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.center)
            .focused($focusedFieldValue, equals: denomination.value)
            
            Button {
                denomination.count += 1
            } label: {
                Image(systemName: "plus")
                    .frame(width: 10, height: 10)
                    .padding(3)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.circle)
            .controlSize(.small)
            
            Spacer()
            
            Text(String(format: "$%.2f", denomination.subtotal))
                .frame(width: 80, alignment: .trailing)
        }
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
