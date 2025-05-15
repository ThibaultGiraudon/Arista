//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData
import SwiftUI

class AddExerciseViewModel: ObservableObject {
    @Published var category: Category = .crossfit
    @Published var date: Date = Date.now
    @Published var duration: Int = 0
    @Published var intensity: Int = 5
    @Published var currentIntensity: Int = 5
    
    /// Shared struct catching error thrown
    let appState = AppState.shared
    
    /// Gradient used as background
    let colorGradients: [[Color]] = [
        .interpolateColors(from: (60, 113, 85), to: (20, 35, 34), steps: 10),
        .interpolateColors(from: (54, 116, 108), to: (21, 33, 38), steps: 10),
        .interpolateColors(from: (47, 100, 120), to: (21, 30, 38), steps: 10),
        .interpolateColors(from: (66, 98, 137), to: (21, 23, 45), steps: 10),
        .interpolateColors(from: (51, 62, 87), to: (19, 15, 37), steps: 10),
        .interpolateColors(from: (75, 63, 137), to: (29, 20, 46), steps: 10),
        .interpolateColors(from: (100, 70, 137), to: (45, 17, 63), steps: 10),
        .interpolateColors(from: (108, 62, 138), to: (47, 16, 57), steps: 10),
        .interpolateColors(from: (132, 70, 126), to: (57, 16, 40), steps: 10),
        .interpolateColors(from: (130, 60, 102), to: (57, 17, 29), steps: 10)
    ]
    
    /// Calculates the effort depending on the given value.
    /// - Parameter value: An `Int` representing the intensity of the exercise
    /// - Returns: A `String` representing the effort:
    ///   - `"Facile"`: if the intensity is between 1 and 3
    ///   - `"Modéré"`: if the intensity is between 4 and 6
    ///   - `"Difficile"`: if the intensity is between 7 and 8
    ///   - `"Maximum"`: otherwise
    func effort(for value: Int) -> String {
        switch value {
            case 1...3:
                return "Facile"
            case 4...6:
                return "Modéré"
            case 7...8:
                return "Difficile"
            default:
                return "Maximum"
        }
    }

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
    }

    /// Add new exercise in the repository.
    func addExercise() {
        do {
            try ExerciseRepository().addExercise(category: category.rawValue, date: date, intensity: intensity, duration: duration)
        } catch {
            appState.reportError("Error adding exercise: \(error.localizedDescription)")
        }
    }
}
