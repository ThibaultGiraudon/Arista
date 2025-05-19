//
//  UserViewModelTests.swift
//  AristaTests
//
//  Created by Thibault Giraudon on 19/05/2025.
//

import XCTest
import CoreData
@testable import Arista

final class UserViewModelTests: XCTestCase {

    var viewContext: NSManagedObjectContext!
    var calendar = Calendar.current

    override func setUp() {
        super.setUp()
        viewContext = PersistenceController.shared.container.viewContext
        calendar.timeZone = TimeZone(secondsFromGMT: 7200)!
        try? DefaultData(viewContext: viewContext).apply()
    }

    override func tearDown() {
        viewContext = nil
        super.tearDown()
    }

    func testUpdateUser() {
        let viewModel = UserDataViewModel(context: viewContext)
        XCTAssertEqual(viewModel.name, "Thibault Giraudon")
        
        viewModel.name = "Charles Leclerc"
        viewModel.saveUser()
        let repository = UserRepository(viewContext: viewContext)
        guard let user = try? repository.getUser() else {
            XCTFail()
            return
        }
        XCTAssertEqual(user.name, "Charles Leclerc")
    }
    
    func testUpdateUserFailed() {
        let context = FailingContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: PersistenceController.shared.container.managedObjectModel)
        let viewModel = UserDataViewModel(context: context)
        
        viewModel.name = "Charles Leclerc"
        viewModel.saveUser()
        XCTAssertEqual(AppState.shared.alertTitle, "Error updating user: Simulated save error")
    }
    
    func testShouldDisable() {
        let viewModel = UserDataViewModel(context: viewContext)
        viewModel.size = 300
        XCTAssertTrue(viewModel.shouldDisable)
    }
    
}
