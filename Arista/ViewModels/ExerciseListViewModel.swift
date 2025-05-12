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
    var averageDuration: Int {
        var total = 0
        exercises.forEach({ total += Int($0.duration) })
        return total / exercises.count
    }
    var calOfDay: Int {
        var total = 0
        for exercise in exercises {
            guard let date = exercise.date else { continue }
            if date.formatted("d MMMM") == Date.now.formatted("d MMMM") {
                total += exercise.calories
            }
        }
        return total
    }

    var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        fetchExercises()
    }

    func fetchExercises() {
        do {
            exercises = try ExerciceRepository().getExercices()
            exercisesPerMonth = Dictionary(grouping: exercises) { exercise -> Date in
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
