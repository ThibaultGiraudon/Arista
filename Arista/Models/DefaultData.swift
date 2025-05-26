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
        
        let exerciseReporsitory = ExerciseRepository(viewContext: viewContext)
        
        let calendar = Calendar.current
        let year = 2025
        
//        deleteAllData(viewContext)
        
        if (try? userRepository.getUser()) == nil {
            let initialUser = User(context: viewContext)
            initialUser.name = "Thibault Giraudon"
            initialUser.email = "thibault.giraudon@gmail.com"
            initialUser.weight = 76.25
            initialUser.hoursSleep = 8
            initialUser.size = 181
            

            if try sleepRepository.getSleepSessions().isEmpty {
                let sleepData: [(day: Int, month: Int, hour: Int, minute: Int, duration: Int, quality: Int16)] = [
                    (5, 05 ,0, 43, 480, 5),
                    (5, 05, 23, 57, 405, 7),
                    (7, 05, 0, 30, 510, 2),
                    (7, 05, 22, 50, 465, 4),
                    (8, 05, 23, 10, 420, 10),
                    (10, 05, 0, 5, 450, 1),
                    (10, 05, 23, 37, 360, 8),
                    (11, 05, 22, 00, 305, 6),
                    (13, 05, 1, 15, 420, 3),
                ]
                
                for data in sleepData {
                    let sleep = Sleep(context: viewContext)

                    let dateComponents = DateComponents(
                        calendar: calendar,
                        timeZone: TimeZone.current,
                        year: year,
                        month: data.month,
                        day: data.day,
                        hour: data.hour,
                        minute: data.minute,
                        second: 0
                    )

                    guard let startDate = calendar.date(from: dateComponents) else { continue }

                    sleep.startDate = startDate
                    sleep.duration = Int64(data.duration)
                    sleep.quality = data.quality
                    sleep.user = initialUser
                }
            }
            
            if try exerciseReporsitory.getExercises().isEmpty {
                let exerciseData: [(day: Int, month: Int, category: String, intensity: Int16, duration: Int64)] = [
                    (30, 04, "Boxe", 10, 60),
                    (10, 05, "Badminton", 3, 63),
                    (12, 05, "Course à pied", 8, 29),
                    (12, 05, "Course à pied", 5, 15),
                ]
                
                for data in exerciseData {
                    let exercise = Exercise(context: viewContext)
                    
                    let dateComponents = DateComponents(
                        calendar: calendar,
                        timeZone: TimeZone.current,
                        year: year,
                        month: data.month,
                        day: data.day,
                        hour: 12,
                        minute: 0,
                        second: 0
                    )
                    
                    guard let date = calendar.date(from: dateComponents) else { continue }
                    
                    exercise.date = date
                    exercise.category = data.category
                    exercise.duration = data.duration
                    exercise.intensity = data.intensity
                    exercise.user = initialUser
                }
            }
             
            try? viewContext.save()
        }
         
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
