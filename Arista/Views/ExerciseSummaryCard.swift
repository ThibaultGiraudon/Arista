//
//  ExerciseSummaryCard.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct ExerciseSummaryCard: View {
    @ObservedObject var viewModel: ExerciseListViewModel

    var body: some View {
        NavigationLink {
            ExerciseListView(viewModel: viewModel)
        } label: {
            VStack(alignment: .leading) {
                let lastExercise = viewModel.exercises.last

                HeaderRow(icon: "flame.fill", title: "Activité", date: lastExercise?.date, isNav: true)
                    .foregroundStyle(.red)

                if let exercise = lastExercise {
                    HStack {
                        Image(systemName: exercise.categoryItem.icon)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(exercise.category ?? "")
                            HStack {
                                Text("\(exercise.duration)")
                                    .font(.title.bold())
                                Text("min")
                            }
                        }
                    }
                } else {
                    Text("Ajouter un premier exercice")
                }
            }
            .cardBackground()
        }
    }
}

#Preview {
    ExerciseSummaryCard(viewModel: ExerciseListViewModel())
}
