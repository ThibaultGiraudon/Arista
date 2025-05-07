//
//  SleepRepository.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

struct SleepRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getSleepSessions() throws -> [Sleep] {
        let request = Sleep.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: true)
        ]
        return try viewContext.fetch(request)
    }
    
    func addSleep(duration: Int, quality: Int, startDate: Date) throws {
        let newSleepSession = Sleep(context: viewContext)
        newSleepSession.duration = Int64(duration)
        newSleepSession.quality = Int16(quality)
        newSleepSession.startDate = startDate
        try viewContext.save()
    }
}
