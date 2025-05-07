//
//  AddSleepSessionView.swift
//  Arista
//
//  Created by Thibault Giraudon on 05/05/2025.
//

import SwiftUI

struct AddSleepSessionView: View {
    @ObservedObject var viewModel: AddSleepSessionViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Section {
                DatePicker("Heure de couché", selection: $viewModel.startDate)
                DatePicker("Heure de reveil", selection: $viewModel.endDate)
                Picker("Qualité", selection: $viewModel.quality) {
                    ForEach(0...10, id: \.self) { value in
                        Text("\(value)")
                    }
                }
                .pickerStyle(.wheel)
            }
        }
        .navigationTitle("Ajouter une période de sommeil")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Ajouter") {
                    viewModel.addSleepSession()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddSleepSessionView(viewModel: AddSleepSessionViewModel())
    }
}
