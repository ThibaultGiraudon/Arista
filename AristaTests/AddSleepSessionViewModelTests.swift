//
//  AddSleepSessionViewModelTests.swift
//  AristaTests
//
//  Created by Thibault Giraudon on 19/05/2025.
//

import XCTest
import CoreData
@testable import Arista

final class AddSleepSessionViewModelTests: XCTestCase {
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
    
    func testAddSleepSessionsSucceed() {
        let viewModel = SleepHistoryViewModel(context: viewContext)
        let addViewModel = AddSleepSessionViewModel(viewContext: viewContext)
        
        XCTAssertEqual(viewModel.sleepSessions.count, 9)
        
        addViewModel.startDate = .now - 86400
        addViewModel.endDate = .now - 61200
        addViewModel.quality = 5
        XCTAssertEqual(addViewModel.duration, 420)
        
        addViewModel.addSleepSession()
        viewModel.fetchSleepSessions()
        XCTAssertEqual(viewModel.sleepSessions.count, 10)
    }
    
    func testAddSleepSessionFailed() {
        let context = FailingContext(concurrencyType: .mainQueueConcurrencyType)
        
        let addViewModel = AddSleepSessionViewModel(viewContext: context)
        addViewModel.startDate = .now - 86400
        addViewModel.endDate = .now - 61200
        addViewModel.quality = 5
        
        addViewModel.addSleepSession()
        
        XCTAssertEqual(AppState.shared.alertTitle, "Error adding sleep session: Simulated save error")
    }
}
