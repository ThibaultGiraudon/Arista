//
//  SleepChartViewModelTests.swift
//  AristaTests
//
//  Created by Thibault Giraudon on 19/05/2025.
//

import XCTest
import CoreData
@testable import Arista

final class SleepChartViewModelTests: XCTestCase {
    var viewContext: NSManagedObjectContext!
    var calendar = Calendar.current
    var timezone = TimeZone.current
    
    override func setUp() {
        viewContext = PersistenceController.shared.container.viewContext
        calendar.timeZone = timezone
        try? DefaultData(viewContext: viewContext).apply()
        super.setUp()
    }
    
    override func tearDown() {
        viewContext = nil
        calendar.timeZone = .current
        super.tearDown()
    }
    
    func testBounds() {
        let viewModel = SleepHistoryViewModel(context: viewContext)
        viewModel.date = .now
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: viewModel.date) else {
            XCTFail()
            return
        }
        let start = weekInterval.start
        let end = weekInterval.end
        XCTAssertEqual(viewModel.xBounds.lower, start)
        XCTAssertEqual(viewModel.xBounds.upper, end)
        XCTAssertEqual(viewModel.xRange, start...end)
        
        calendar.timeZone = TimeZone(secondsFromGMT: 3600)!
        
        let baseDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1)) ?? .distantPast

        let startHour = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: baseDate) ?? baseDate
        let endHour = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: baseDate.addingTimeInterval(86400)) ?? baseDate
        XCTAssertEqual(viewModel.yBounds.lower, startHour)
        XCTAssertEqual(viewModel.yBounds.upper, endHour)
        XCTAssertEqual(viewModel.yRange, startHour...endHour)
    }
    
    func testChartDatas() {
        let viewModel = SleepHistoryViewModel(context: viewContext)
        viewModel.deleteSleepSessions(viewModel.sleepSessions)
        
        timezone = TimeZone(secondsFromGMT: 3600)!
        calendar.timeZone = timezone
        var component = DateComponents(calendar: calendar, timeZone: timezone, year: 2025, month: 3, day: 3, hour: 23, minute: 33)
        guard let date = calendar.date(from: component) else {
            XCTFail()
            return
        }
        
        component = DateComponents(calendar: calendar, timeZone: timezone, year: 2025, month: 3, day: 4)
        guard var day = calendar.date(from: component) else {
            XCTFail()
            return
        }
        
        print(day.formatted("dd MMMM YYYY HH:mm"))
        
        component = DateComponents(calendar: calendar, timeZone: timezone, year: 2000, month: 1, day: 1, hour: 23, minute: 33)
        guard let start = calendar.date(from: component) else {
            XCTFail()
            return
        }
        print(start.formatted("dd MMMM YYYY HH:mm"))
        
        component = DateComponents(calendar: calendar, timeZone: timezone, year: 2000, month: 1, day: 2, hour: 3, minute: 33)
        guard let end = calendar.date(from: component) else {
            XCTFail()
            return
        }
        print(end.formatted("dd MMMM YYYY HH:mm"))
        
        viewModel.date = day
        
        addSleepSession(context: viewContext, date: date, quality: 5, duration: 240)
        viewModel.fetchSleepSessions()
        
        XCTAssertEqual(viewModel.chartDatas.count, 1)
        guard let data = viewModel.chartDatas.first else {
            XCTFail()
            return
        }
        
        day += 86400
        XCTAssertEqual(data.start, start + 3600)
        XCTAssertEqual(data.end, end + 3600)
    }
}

private func addSleepSession(context: NSManagedObjectContext, date: Date, quality: Int16, duration: Int64) {
    let sleep = Sleep(context: context)
    print(date)
    sleep.startDate = date
    print(sleep.startDate!)
    sleep.quality = quality
    sleep.duration = duration
    try? context.save()
}
