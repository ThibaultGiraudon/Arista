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
                List(viewModel.sortedExercises, id: \.0) { month, exercices in
                    Section("\(month.formatted("MMMM YYYY"))") {
                        ForEach(exercices, id: \.self) { exercise in
                            NavigationLink {
                                ExerciseDetailView(exercise: exercise)
                            } label: {
                                ExerciseRowView(exercise: exercise)
                            }
                        }
                        .onDelete { indexes in
                            let exerciseToDelete = indexes.map { exercices[$0] }
                            viewModel.deleteExercises(exerciseToDelete)
                        }
                    }
                    .listRowBackground(Color("OffWhite"))
                }
                .scrollContentBackground(.hidden)
            }
            .background {
                Color("DimGray")
                    .ignoresSafeArea()
            }
            .foregroundStyle(Color("TextColor"))
            .navigationTitle("Exercices")
            .navigationBarItems(trailing: Button(action: {
                showingAddExerciseView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showingAddExerciseView, onDismiss: viewModel.fetchExercises) {
            NavigationStack {
                AddExerciseView(viewModel: AddExerciseViewModel(context: viewModel.viewContext))
            }
        }
        
    }
}

#Preview {
    ExerciseListView(viewModel: ExerciseListViewModel(context: PersistenceController.preview.container.viewContext))
}
