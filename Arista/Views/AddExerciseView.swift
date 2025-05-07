//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel
    @State private var showIntensityPicker = false

    var body: some View {
        VStack {
            Form {
                Section("Détail") {
                    Picker("Catégorie", selection: $viewModel.category) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text("\(category)")
                        }
                    }
                    DatePicker("Date", selection: $viewModel.date)
                    TextField("Durée (en minutes)", value: $viewModel.duration, format: .number)
                }
                Section("Effort") {
                    Button {
                        showIntensityPicker = true
                    } label: {
                        HStack {
                            Text("\(viewModel.intensity)")
                                .foregroundStyle(viewModel.currentColor)
                                .font(.title.bold())
                                .padding()
                                .background {
                                    Circle()
                                        .foregroundStyle(viewModel.currentColor.opacity(0.3))
                                }
                            Spacer()
                            IntensityView(intensity: viewModel.intensity)
                        }
                    }
                }
            }.formStyle(.grouped)
            Spacer()
            Button("Ajouter l'exercice") {
                if viewModel.addExercise() {
                    presentationMode.wrappedValue.dismiss()
                }
            }.buttonStyle(.borderedProminent)
                
        }
        .navigationTitle("Nouvel Exercice ...")
        .sheet(isPresented: $showIntensityPicker) {
            NavigationStack {
                IntensityPickerView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
