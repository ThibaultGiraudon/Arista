//
//  +Chart.swift
//  Arista
//
//  Created by Thibault Giraudon on 14/05/2025.
//

import Foundation
import SwiftUI

extension SleepHistoryViewModel {
    /// The lower and upper bounds of the x-axis for the chart, based on the current date.
    /// This range represents the start and end of the week containing the current date.
    /// - Returns: A tuple containing the lower and upper bounds of the x-axis, where `lower` is the start of the week, and `upper` is the end of the week.
    var xBounds: (lower: Date, upper: Date) { getXAxisBounds(for: date) }
    
    /// The lower and upper bounds of the y-axis for the chart.
    /// This range represents the start and end of the night.
    /// - Returns: A tuple containing the lower and upper bounds of the y-axis, where `lower` is the start of the night, and `upper` is the end of the night.
    var yBounds: (lower: Date, upper: Date) { getYAxisBounds() }


    /// The range for the x-axis, representing the start and end of the week containing the current date.
    /// This range is used to display the days of the current week on the chart.
    /// - Returns: A `ClosedRange` from the first day of the current week to the last day of the current week.
    var xRange: ClosedRange<Date> { xBounds.lower...xBounds.upper }

    /// The range for the y-axis, representing the start and end of the night.
    /// This range is used to display the sleeping hours on the chart.
    /// - Returns: A `ClosedRange` from the start of the night (8:00 PM) to the end of the night (10:00 AM).
    var yRange: ClosedRange<Date> { yBounds.lower...yBounds.upper }

    /// All days in the week of the current date.
    /// This array is used to display one full week, starting from the first day of the week.
    /// - Returns: An array of `Date` values representing each day of the current week.
    private var daysInWeek: [Date] { generateDaysInWeek(for: date) }
    
    /// All sleep sessions of the current week formatted for chart display.
    /// Each session is normalized to a reference date to align times across multiple days.
    /// - Returns: An array of `ChartSleepData` representing sleep sessions for each day of the current week.
    var chartDatas: [ChartSleepData] {
        daysInWeek.compactMap { day in
            guard let sleep = self.getSleepSession(for: day) else { return nil }
            let start = self.normalizeToReferenceDay(sleep.startDate ?? day)
            let end = self.normalizeToReferenceDay(sleep.endDate)
            return ChartSleepData(day: day, start: start, end: end)
        }
    }

    // MARK: - Gesture

    /// A gesture that allows the user to navigate between weeks.
    /// Swiping left advances to the next week, while swiping right goes back to the previous one.
    /// - Returns: A `Gesture` that updates the displayed week based on horizontal drag direction.
    var gesture: some Gesture {
        DragGesture()
            .onEnded { value in
                if value.translation.width < -50 {
                    self.moveToNextWeek()
                } else if value.translation.width > 50 {
                    self.moveToPreviousWeek()
                }
            }
    }
    
    /// Advances the current date by one week, unless it would result in a future date.
    /// This prevents navigating beyond the current week.
    private func moveToNextWeek() {
        guard let newDate = calendar.date(byAdding: .day, value: 7, to: date) else { return }
        let today = calendar.startOfDay(for: Date())
        if calendar.startOfDay(for: newDate) <= today {
            date = newDate
        }
    }

    /// Moves the date back by one week.
    private func moveToPreviousWeek() {
        guard let newDate = calendar.date(byAdding: .day, value: -7, to: date) else { return }
        date = newDate
    }
    
    // MARK: - Helper
    
    /// Normalizes a given date to a reference day (January 1, 2000).
    /// The normalized date will have the same time (hour, minute, second) as the provided date.
    /// If the provided date is after midnight and it’s not the first day, it will be normalized to January 2, 2000.
    /// - Parameters:
    ///   - date: The date to normalize.
    ///   - isFirstDay: A boolean flag indicating whether it’s the first day. If `false`, the date will be adjusted to the next day.
    /// - Returns: A `Date` object normalized to the reference day with the same time components.
    private func normalizeToReferenceDay(_ date: Date) -> Date {
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        var baseComponents = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2000,
            month: 1,
            day: 1,
            hour: components.hour,
            minute: components.minute,
            second: components.second
        )

        if let hour = baseComponents.hour, hour < 12 {
            baseComponents.day! += 1
        }

        return calendar.date(from: baseComponents)!
    }
    
    /// Generates all days of the week that contain the given date.
    /// - Parameter date: A date within the target week.
    /// - Returns: An array of `Date` objects representing each day of the week.
    private func generateDaysInWeek(for date: Date) -> [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: date) else { return [] }

        var days: [Date] = []
        var currentDate = weekInterval.start

        while currentDate < weekInterval.end {
            days.append(currentDate)
            guard let next = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = next
        }

        return days
    }
    
    // MARK: - Bounds
    
    /// Returns the bounds of a typical night period for the sleep chart.
    /// The night starts at 8 PM and ends at 10 AM the following day.
    /// - Returns: A tuple containing the lower and upper `Date` bounds of the night.
    private func getYAxisBounds() -> (lower: Date, upper: Date) {
        let baseDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1)) ?? .distantPast

        let lower = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: baseDate) ?? baseDate
        let upper = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: baseDate.addingTimeInterval(86400)) ?? baseDate

        return (lower, upper)
    }

    /// Returns the bounds of the week from the given date for the sleep chart.
    /// - Returns: A tuple containing the first and the last `Date` bounds of the week.
     private func getXAxisBounds(for date: Date) -> (lower: Date, upper: Date) {
         let calendar = Calendar.current
         guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: date) else { return (.now, .now) }
         let lower = weekInterval.start
         let upper = weekInterval.end
         return (lower, upper)
     }

}
