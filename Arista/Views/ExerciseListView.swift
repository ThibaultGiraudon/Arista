//
//  ExerciseListView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    @State private var showingAddExerciseView = false
    
    var body: some View {
        NavigationView {
                VStack(alignment: .leading) {
                    List(viewModel.exercisesPerMonth.sorted(by: { $0.key > $1.key }), id: \.key) { month, exercices in
                        Section("\(month, format: .dateTime.month().year())") {
                            ForEach(exercices, id: \.self) { exercice in
                                HStack {
                                    Image(systemName: iconForCategory(exercice.category ?? ""))
                                        .font(.largeTitle)
                                    VStack(alignment: .leading) {
                                        Text(exercice.category ?? "")
                                            .font(.title3)
                                        Text("\(exercice.duration)")
                                            .font(.largeTitle)
                                    }
                                    Spacer()
                                    IntensityView(intensity: Int(exercice.intensity))
                                }
                            }
                        }
                    }
                }
            .navigationTitle("Exercices")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExerciseView, onDismiss: viewModel.fetchExercises) {
            AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext))
        }
        
    }
    
    func iconForCategory(_ category: String) -> String {
        var icon = "questionmark"
        Category.allCases.forEach { value in
            if value.rawValue == category {
                icon = value.icon
            }
        }
        return icon
    }
}

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
