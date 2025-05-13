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
    @Published var exercisesPerMonth = [Date: [Exercice]]()
    var sortedExercises: [(Date, [Exercice])] {
        exercisesPerMonth.map { key, exercises in
            let sortedExercises = exercises.sorted(by: {$0.date ?? .now > $1.date ?? .now})
            return (key, sortedExercises)
        }.sorted(by: { $0.0 > $1.0 })
    }
    
    let appState = AppState.shared
    
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
    
    func averageDuration(from: Date = .distantPast, to: Date = .now) -> Int {
        var total = 0
        var count = 0
        
        for exercise in exercises {
            guard let date = exercise.date else { continue }
            guard date >= from && date <= to else { continue }
            
            total += Int(exercise.duration)
            count += 1
        }
        
        guard count > 0 else { return 0 }
        
        return total / exercises.count
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
            appState.reportError("Error fetching exercises: \(error.localizedDescription)")
        }
    }
    
    func deleteExercises(_ exercisesToDelete: [Exercice], for key: Date) {
        guard var exercises = exercisesPerMonth[key] else { return }

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

extension ExerciseListViewModel {
    func durationTrend() -> String {
        let now = Date.now
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        
        let recent = averageDuration(from: lastWeek, to: now)
        let older = averageDuration(from: .distantPast, to: lastWeek)
        
        return compareTrend(recent: recent, older: older)
    }
    
    private func compareTrend(recent: Int, older: Int) -> String {
        let diff = recent - older
        let threshold = 5

        if diff > threshold {
            return "chevron.up"
        } else if diff < -threshold {
            return "chevron.down"
        } else {
            return "minus"
        }
    }
    
}
