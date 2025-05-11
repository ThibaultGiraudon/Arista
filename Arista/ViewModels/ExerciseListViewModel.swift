//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

import CoreData

class ExerciseListViewModel: ObservableObject {
    @Published var exercises: [Exercice] = []
    @Published var exercisesPerMonth: [Date: [Exercice]] = [:]

    var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchExercises()
    }

    func fetchExercises() {
        do {
            let components = try ExerciceRepository().getExercices()
            exercisesPerMonth = Dictionary(grouping: components) { exercise -> Date in
                let components = Calendar.current.dateComponents([.year, .month], from: exercise.date ?? .now)
                if let date = Calendar.current.date(from: components) {
                    return date
                }
                return .now
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
