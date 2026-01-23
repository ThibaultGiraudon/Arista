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
        
        deleteAllData(viewContext)
        
        if (try? userRepository.getUser()) == nil {
            let initialUser = User(context: viewContext)
            initialUser.name = "Thibault Giraudon"
            initialUser.email = "thibault.giraudon@gmail.com"
            initialUser.weight = 76.25
            initialUser.hoursSleep = 8
            initialUser.size = 181
            

            if try sleepRepository.getSleepSessions().isEmpty {
                let sleepData: [(day: Int, month: Int, hour: Int, minute: Int, duration: Int, quality: Int16)] = [
                    (15, 09 ,0, 43, 480, 5),
                    (15, 09, 23, 57, 405, 7),
                    (17, 09, 0, 30, 510, 2),
                    (17, 09, 22, 50, 465, 4),
                    (18, 09, 23, 10, 420, 10),
                    (20, 09, 0, 5, 450, 1),
                    (20, 09, 23, 37, 360, 8),
                    (21, 09, 22, 00, 305, 6),
                    (23, 09, 1, 15, 420, 3),
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
                    (30, 07, "Boxe", 10, 60),
                    (10, 08, "Badminton", 3, 63),
                    (12, 08, "Course à pied", 8, 29),
                    (12, 08, "Course à pied", 5, 15),
                    (15, 08, "Natation", 6, 45),
                    (18, 08, "Musculation", 7, 50),
                    (20, 08, "Yoga", 2, 40),
                    (02, 09, "Randonnée", 4, 120),
                    (05, 09, "Natation", 7, 60),
                    (10, 09, "Musculation", 6, 50)
                ]
                
                for data in exerciseData {
                    let exercise = Exercise(context: viewContext)
                    
                    let dateComponents = DateComponents(
                        calendar: calendar,
                        timeZone: TimeZone.current,
                        year: year,
                        month: data.month,
                        day: data.day,
                        hour: Int.random(in: 8...20),
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
