//
//  SleepHistoryViewModelTests.swift
//  AristaTests
//
//  Created by Thibault Giraudon on 19/05/2025.
//

import XCTest
import CoreData
@testable import Arista

final class SleepHistoryViewModelTests: XCTestCase {

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

    func testFetchSleepSessionSucceed() {
        let viewModel = SleepHistoryViewModel(context: viewContext)
        
        XCTAssertEqual(viewModel.sleepSessions.count, 9)
        XCTAssertEqual(viewModel.sortedSleepSessions.count, 2)
        
        guard let first = viewModel.sortedSleepSessions.first else {
            XCTFail()
            return
        }
        
        guard let last = viewModel.sortedSleepSessions.last else {
            XCTFail()
            return
        }
        XCTAssert(first.0 > last.0)
    }
    
    func testGetSleepSessionSucceed() {
        let sleepSession = Sleep(context: viewContext)
        let components = DateComponents(calendar: calendar, timeZone: TimeZone.current, year: 2025, month: 3, day: 3)
        guard let date = calendar.date(from: components) else {
            XCTFail()
            return
        }
        sleepSession.startDate = date
        sleepSession.duration = 420
        sleepSession.quality = 5
        
        try? viewContext.save()
        
        let viewModel = SleepHistoryViewModel(context: viewContext)
        
        guard let session = viewModel.getSleepSession(for: date) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(sleepSession, session)
    }
    
    func testGetSleepSucceed() {
        let sleepSession = Sleep(context: viewContext)
        let components = DateComponents(calendar: calendar, timeZone: TimeZone.current, year: 2025, month: 3, day: 3)
        guard let date = calendar.date(from: components) else {
            XCTFail()
            return
        }
        sleepSession.startDate = date
        sleepSession.duration = 420
        sleepSession.quality = 5
        
        try? viewContext.save()
        
        let viewModel = SleepHistoryViewModel(context: viewContext)
        
        let sleep = viewModel.getSleep(for: date)
        
        XCTAssertEqual(date, sleep.start)
        XCTAssertEqual(date + 25200, sleep.end)
    }

    func testDeleteSleepSessionsSucceed() {
        let viewModel = SleepHistoryViewModel(context: viewContext)
        let sleepsToDelete = Array(viewModel.sleepSessions.prefix(3))
        viewModel.deleteSleepSessions(sleepsToDelete)
        XCTAssertEqual(viewModel.sleepSessions.count, 6)
    }
    
    func testDeletesleepSessionsFailed() {
        let context = FailingContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: PersistenceController(inMemory: true).container.managedObjectModel)
        
        let viewModel = SleepHistoryViewModel(context: context)
        
        let sleep = Sleep(context: context)
        sleep.startDate = Date()
        sleep.duration = 420
        sleep.quality = 5

        viewModel.sleepSessions = [sleep]

        viewModel.deleteSleepSessions([sleep])

        XCTAssertEqual(AppState.shared.alertTitle, "Error deleting sleep session: Simulated save error")
    }
    
    func testAddSleepSessionWithoutDate() {
        let viewModel = SleepHistoryViewModel(context: viewContext)
        viewModel.deleteSleepSessions(viewModel.sleepSessions)
        addSleepSession(context: viewContext, date: nil, quality: 5, duration: 30)
        viewModel.fetchSleepSessions()
        guard let sleep = viewModel.sleepSessions.first else {
            XCTFail()
            return
        }
        XCTAssertEqual(sleep.endDate, .now)
    }
    
    func testAverageDuration() {
        
        let viewModel = SleepHistoryViewModel(context: viewContext)
        viewModel.deleteSleepSessions(viewModel.sleepSessions)
        addSleepSession(context: viewContext, date: .now - 86400, quality: 5, duration: 420)
        viewModel.fetchSleepSessions()
        
        XCTAssertEqual(viewModel.averageSleep(), 420)
    }
    
    func testDurationTrend() {
        let viewModel = SleepHistoryViewModel(context: viewContext)
        viewModel.deleteSleepSessions(viewModel.sleepSessions)
        
        addSleepSession(context: viewContext, date: .now - 86400, quality: 5, duration: 360)
        viewModel.fetchSleepSessions()
        XCTAssertEqual(viewModel.sleepTrend(), "chevron.up")
        
        addSleepSession(context: viewContext, date: .distantPast, quality: 5, duration: 360)
        viewModel.fetchSleepSessions()
        XCTAssertEqual(viewModel.sleepTrend(), "minus")
        
        addSleepSession(context: viewContext, date: .distantPast, quality: 5, duration: 600)
        viewModel.fetchSleepSessions()
        XCTAssertEqual(viewModel.sleepTrend(), "chevron.down")
    }
    
}

private func addSleepSession(context: NSManagedObjectContext, date: Date?, quality: Int16, duration: Int64) {
    let sleep = Sleep(context: context)
    sleep.startDate = date
    sleep.quality = quality
    sleep.duration = duration
    try? context.save()
}
