//
//  DefaultData.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

struct DefaultData {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
 
    func apply() throws {
        let userRepository = UserRepository(viewContext: viewContext)
        
        let sleepRepository = SleepRepository(viewContext: viewContext)
        
//        deleteAllData(viewContext)
        
        if (try? userRepository.getUser()) == nil {
            let initialUser = User(context: viewContext)
            initialUser.name = "Thibault Giraudon"
            initialUser.email = "thibault.giraudon@gmail.com"
            initialUser.password = "test123"

            if try sleepRepository.getSleepSessions().isEmpty {
                for dayOffset in -6...0 { // les 7 derniers jours
                    let sleep = Sleep(context: viewContext)
                    
                    // Définir une date de départ réaliste : entre 21h et 01h
                    let bedtimeHour = Int.random(in: 21...24)
                    let bedtimeMinute = Int.random(in: 0...59)
                    
                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
                    let today = calendar.startOfDay(for: Date())
                    let bedtime = calendar.date(byAdding: .day, value: dayOffset, to: today)!
                    let bedtimeDate = calendar.date(bySettingHour: bedtimeHour % 24, minute: bedtimeMinute, second: 0, of: bedtime)!

                    // Durée aléatoire entre 6 et 9 heures
                    let durationInMinutes = Int64(Int.random(in: 360...540))
                    sleep.duration = durationInMinutes
                    sleep.startDate = bedtimeDate
                    sleep.quality = Int16.random(in: 5...10)
                    sleep.user = initialUser
                }

            }
             
            try? viewContext.save()
        }
         
        }
    
    func randomElement() -> Double {
        Double((-2...2).randomElement()!) * 3600
    }
    
    func deleteAllData(_ context: NSManagedObjectContext) {
        let persistentStoreCoordinator = context.persistentStoreCoordinator

        for entityName in persistentStoreCoordinator?.managedObjectModel.entities.compactMap({ $0.name }) ?? [] {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs

            do {
                let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
                let objectIDs = result?.result as? [NSManagedObjectID] ?? []
                let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            } catch {
                print("Erreur lors de la suppression de \(entityName): \(error)")
            }
        }
    }

}
