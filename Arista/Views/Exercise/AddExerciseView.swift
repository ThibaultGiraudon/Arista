//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddExerciseViewModel
    @State private var showIntensityPicker = false

    var body: some View {
        VStack {
            Form {
                Section("Détail") {
                    Picker("Catégorie", selection: $viewModel.category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue)
                        }
                    }
                    DatePicker("Date", selection: $viewModel.date)
                    TextField("Durée (en minutes)", value: $viewModel.duration, format: .number)
                        .keyboardType(.numberPad)
                }
                Section("Effort") {
                    Button {
                        showIntensityPicker = true
                    } label: {
                        IntensityRowView(intensity: viewModel.intensity)
                    }
                }
            }
        }
        .navigationTitle("Ajouter un exercice")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuler") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Ajouter") {
                    viewModel.addExercise()
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showIntensityPicker) {
            NavigationStack {
                IntensityPickerView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.shared.container.viewContext))
}
