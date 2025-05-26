//
//  AristaTests.swift
//  AristaTests
//
//  Created by Thibault Giraudon on 15/05/2025.
//

import XCTest
import CoreData
@testable import Arista

class FailingContext: NSManagedObjectContext {
    override func save() throws {
        throw NSError(domain: "Test", code: 999, userInfo: [NSLocalizedDescriptionKey: "Simulated save error"])
    }
}

final class ExerciseListViewModelTests: XCTestCase {

    var viewContext: NSManagedObjectContext!
    var calendar = Calendar.current

    override func setUp() {
        super.setUp()
        viewContext = PersistenceController(inMemory: true).container.viewContext
        calendar.timeZone = TimeZone(secondsFromGMT: 7200)!
        try? DefaultData(viewContext: viewContext).apply()
    }

    override func tearDown() {
        viewContext = nil
        super.tearDown()
    }

    func testFetchExercisesSucceed() {
        let viewModel = ExerciseListViewModel(context: viewContext)
        
        XCTAssertEqual(viewModel.exercises.count, 4)
        XCTAssertEqual(viewModel.sortedExercises.count, 2)
        
        guard let first = viewModel.sortedExercises.first else {
            XCTFail()
            return
        }
        
        guard let last = viewModel.sortedExercises.last else {
            XCTFail()
            return
        }
        XCTAssert(first.0 > last.0)
    }

    func testDeleteExercisesSucceed() {
        let viewModel = ExerciseListViewModel(context: viewContext)
        let exercisesToDelete = Array(viewModel.exercises.prefix(2))
        viewModel.deleteExercises(exercisesToDelete)
        XCTAssertEqual(viewModel.exercises.count, 2)
    }
    
    func testDeleteExercisesFailed() {
        let context = FailingContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: PersistenceController(inMemory: true).container.managedObjectModel)
        
        let viewModel = ExerciseListViewModel(context: context)
        
        let exercise = Exercise(context: context)
        exercise.date = Date()
        exercise.duration = 30
        exercise.intensity = 5
        exercise.category = "CrossFit"

        viewModel.exercises = [exercise]

        viewModel.deleteExercises([exercise])

        XCTAssertEqual(AppState.shared.alertTitle, "Erreur lors de la suppression : Simulated save error")
    }
    
    func testAddExerciseWithoutDate() {
        let viewModel = ExerciseListViewModel(context: viewContext)
        viewModel.deleteExercises(viewModel.exercises)
        addExercise(context: viewContext, date: nil, category: "Course à pied", intensity: 5, duration: 30)
        viewModel.fetchExercises()
    }
    
    func testCalOfDay() {
        addExercise(context: viewContext, date: .now, category: "CrossFit", intensity: 5, duration: 30)
        let calOfDay = Int(30.0 / 60.0 * 8.0 * 75)
        
        let viewModel = ExerciseListViewModel(context: viewContext)
        
        XCTAssertEqual(viewModel.calOfDay, calOfDay)
    }
    
    func testAverageDuration() {
        let viewModel = ExerciseListViewModel(context: viewContext)
        
        XCTAssertEqual(viewModel.averageDuration(), 41)
    }
    
    func testDurationTrend() {
        let viewModel = ExerciseListViewModel(context: viewContext)
        viewModel.deleteExercises(viewModel.exercises)
        
        addExercise(context: viewContext, date: .now, category: "CrossFit", intensity: 5, duration: 30)
        viewModel.fetchExercises()
        XCTAssertEqual(viewModel.durationTrend(), "chevron.up")
        
        addExercise(context: viewContext, date: .distantPast, category: "CrossFit", intensity: 5, duration: 30)
        viewModel.fetchExercises()
        XCTAssertEqual(viewModel.durationTrend(), "minus")
        
        addExercise(context: viewContext, date: .distantPast, category: "CrossFit", intensity: 5, duration: 60)
        viewModel.fetchExercises()
        XCTAssertEqual(viewModel.durationTrend(), "chevron.down")
    }
    
}

private func addExercise(context: NSManagedObjectContext, date: Date?, category: String, intensity: Int16, duration: Int64) {
    let exercise = Exercise(context: context)
    exercise.date = date
    exercise.category = category
    exercise.intensity = intensity
    exercise.duration = duration
    try? context.save()
}
