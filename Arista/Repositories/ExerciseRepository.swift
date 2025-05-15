//
//  ExerciseRepository.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

struct ExerciseRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getExercises() throws -> [Exercise] {
        let request = Exercise.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        return try viewContext.fetch(request)
    }
    
    func addExercise(category: String, date: Date, intensity: Int, duration: Int) throws {
        let newExercise = Exercise(context: viewContext)
        newExercise.date = date
        newExercise.intensity = Int16(intensity)
        newExercise.duration = Int64(duration)
        newExercise.category = category
        try viewContext.save()
    }
}
