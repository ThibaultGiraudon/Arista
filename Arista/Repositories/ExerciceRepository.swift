//
//  ExerciceRepository.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

struct ExerciceRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getExercices() throws -> [Exercice] {
        let request = Exercice.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        return try viewContext.fetch(request)
    }
    
    func addExercice(category: String, date: Date, intensity: Int, duration: Int) throws {
        let newExercice = Exercice(context: viewContext)
        newExercice.date = date
        newExercice.intensity = Int16(intensity)
        newExercice.duration = Int64(duration)
        newExercice.category = category
        try viewContext.save()
    }
}
