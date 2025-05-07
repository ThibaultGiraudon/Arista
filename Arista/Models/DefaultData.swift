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
        
        deleteAllData(viewContext)
        
        if (try? userRepository.getUser()) == nil {
            let initialUser = User(context: viewContext)
            initialUser.name = "Thibault Giraudon"
            initialUser.email = "thibault.giraudon@gmail.com"
            initialUser.password = "test123"
            

            if try sleepRepository.getSleepSessions().isEmpty {
                // Exemples : 7 sessions récentes (heure de coucher au même jour que réveil)
                let sleepData: [(day: Int, month: Int, hour: Int, minute: Int, duration: Int)] = [
                    (5, 05 ,0, 43, 480),   // 8h00
                    (5, 05, 23, 57, 405),  // 6h45
                    (6, 05, 1, 15, 390),   // 6h30
                    (7, 05, 0, 30, 510),   // 8h30
                    (7, 05, 22, 50, 465),  // 7h45
                    (8, 05, 23, 10, 420),  // 7h00
                    (10, 05, 0, 5, 450)    // 7h30
                ]

                let calendar = Calendar.current
                let year = 2025
                
                for data in sleepData {
                    let sleep = Sleep(context: viewContext)

                    let dateComponents = DateComponents(
                        calendar: calendar,
                        timeZone: TimeZone.current, // Ou spécifiquement TimeZone(identifier: "Europe/Paris")
                        year: year,
                        month: data.month,
                        day: data.day,
                        hour: data.hour,
                        minute: data.minute,
                        second: 0
                    )

                    guard let startDate = calendar.date(from: dateComponents) else { continue }

                    sleep.startDate = startDate
                    sleep.duration = Int64(data.duration) // minutes
                    sleep.quality = Int16.random(in: 0...10)
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
