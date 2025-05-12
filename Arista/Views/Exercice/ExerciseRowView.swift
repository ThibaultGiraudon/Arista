//
//  ExerciseRowView.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct ExerciseRowView: View {
    var exercise: Exercice
    var body: some View {
        HStack {
            Image(systemName: exercise.categoryItem.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .padding()
                .background {
                    Circle()
                        .foregroundStyle(.gray.opacity(0.2))
                }
            VStack(alignment: .leading) {
                Text(exercise.categoryItem.rawValue)
                    .font(.title3)
                Text("\(exercise.duration) min")
                    .font(.largeTitle)
            }
            Spacer()
            IntensityView(intensity: Int(exercise.intensity))
        }
    }
}

#Preview {
    ExerciseRowView(exercise: ExerciseListViewModel().exercises.first!)
}
