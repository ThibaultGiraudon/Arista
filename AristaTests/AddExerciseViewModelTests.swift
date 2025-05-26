//
//  AddExerciseViewModelTests.swift
//  AristaTests
//
//  Created by Thibault Giraudon on 19/05/2025.
//

import XCTest
import CoreData
@testable import Arista

final class AddExerciseViewModelTests: XCTestCase {
    var viewContext: NSManagedObjectContext!
    let calendar = Calendar.current

    override func setUp() {
        super.setUp()
        viewContext = PersistenceController(inMemory: true).container.viewContext
        try? DefaultData(viewContext: viewContext).apply()
    }

    override func tearDown() {
        viewContext = nil
        super.tearDown()
    }

    func testaddExerciseSucceed() {
        let viewModel = ExerciseListViewModel(context: viewContext)
        let addViewModel = AddExerciseViewModel(context: viewContext)
        
        XCTAssertEqual(viewModel.exercises.count, 4)
        
        addViewModel.intensity = 5
        addViewModel.category = .badminon
        addViewModel.duration = 50
        addViewModel.date = .now
        
        addViewModel.addExercise()
        viewModel.fetchExercises()
        XCTAssertEqual(viewModel.exercises.count, 5)
        
        XCTAssertEqual(addViewModel.effort(for: 1), "Facile")
        XCTAssertEqual(addViewModel.effort(for: 5), "Modéré")
        XCTAssertEqual(addViewModel.effort(for: 8), "Difficile")
        XCTAssertEqual(addViewModel.effort(for: 9), "Maximum")
    }
    
    func testAddExerciseFailed() {
        let context = FailingContext(concurrencyType: .mainQueueConcurrencyType)
//        context.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: PersistenceController(inMemory: true).container.managedObjectModel)
        
        let addViewModel = AddExerciseViewModel(context: context)
        addViewModel.intensity = 5
        addViewModel.category = .badminon
        addViewModel.date = .now
        addViewModel.duration = 30
        
        addViewModel.addExercise()
        
        XCTAssertEqual(AppState.shared.alertTitle, "Error adding exercise: Simulated save error")
    }
}
