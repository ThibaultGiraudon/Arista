//
//  AddSleepSessionView.swift
//  Arista
//
//  Created by Thibault Giraudon on 05/05/2025.
//

import SwiftUI

struct AddSleepSessionView: View {
    @StateObject var viewModel = AddSleepSessionViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Form {
            Section("Perdiode") {
                DatePicker("Début:", selection: $viewModel.startDate, in: ...Date.now)
                DatePicker("Fin:", selection: $viewModel.endDate, in: viewModel.startDate...Date.now)
            }
            Section("Qualité") {
                SleepQualityPicker(quality: $viewModel.quality)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Ajouter") {
                    viewModel.addSleepSession()
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddSleepSessionView()
    }
}
