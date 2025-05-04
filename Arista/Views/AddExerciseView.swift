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

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Catégorie", text: $viewModel.category)
                    DatePicker("Date", selection: $viewModel.date)
                    TextField("Durée (en minutes)", value: $viewModel.duration, format: .number)
                    NavigationLink {
                        IntensityPickerView(viewModel: viewModel)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("Effort ±")
                            Text("\(viewModel.intensity)")
                                .foregroundStyle(viewModel.currentColor)
                                .font(.title.bold())
                                .padding()
                                .background {
                                    Circle()
                                        .foregroundStyle(viewModel.currentColor.opacity(0.3))
                                }
                        }
                    }
                    .pickerStyle(.wheel)
                }.formStyle(.grouped)
                Spacer()
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }.buttonStyle(.borderedProminent)
                    
            }
            .navigationTitle("Nouvel Exercice ...")
            
        }
    }
}

#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
