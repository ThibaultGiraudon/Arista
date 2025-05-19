//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class ExerciseListViewModel: ObservableObject {
    /// All exercises from CoreData.
    @Published var exercises: [Exercise] = []
    /// All exercises grouped by months.
    @Published var exercisesPerMonth = [Date: [Exercise]]()
    /// All exercises grouped by months and sorted ascending.
    var sortedExercises: [(Date, [Exercise])] {
        exercisesPerMonth.map { key, exercises in
            let sortedExercises = exercises.sorted(by: {$0.date ?? .now > $1.date ?? .now})
            return (key, sortedExercises)
        }.sorted(by: { $0.0 > $1.0 })
    }
    
    /// Shared struct catching error thrown.
    let appState = AppState.shared

    var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        fetchExercises()
    }

    /// Loads all exercises from the repository and updates the local state.
    /// Groupeds exercises by months and updates the local state.
    func fetchExercises() {
        do {
            exercises = try ExerciseRepository(viewContext: viewContext).getExercises()
            exercisesPerMonth = Dictionary(grouping: exercises) { exercise -> Date in
                let components = Calendar.current.dateComponents([.year, .month], from: exercise.date ?? .now)
                if let date = Calendar.current.date(from: components) {
                    return date
                }
                return .now
            }
        } catch {
            appState.reportError("Error fetching exercises: \(error.localizedDescription)")
        }
    }
    
    /// Deletes all given exercises and fetches back all exercises remaining.
    /// - Parameter exercisesToDelete: An array of `Exercise` that should be deleted.
    func deleteExercises(_ exercisesToDelete: [Exercise]) {
        for exercise in exercisesToDelete {
            viewContext.delete(exercise)
        }

        do {
            try viewContext.save()
            fetchExercises()
        } catch {
            AppState.shared.reportError("Erreur lors de la suppression : \(error.localizedDescription)")
        }
    }
}
