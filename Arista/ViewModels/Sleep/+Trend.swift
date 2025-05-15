//
//  +Trend.swift
//  Arista
//
//  Created by Thibault Giraudon on 15/05/2025.
//

import SwiftUI

extension SleepHistoryViewModel {
    /// Calculates the average sleep's duration within a given date range.
    /// - Parameters:
    ///   - from: The start date of the range. Defaults to `.distantPast`.
    ///   - to: The end date of the range. Defaults to `.now`.
    /// - Returns: The average duration (in minutes) of the sleep during the specified period.
    func averageSleep(from: Date = .distantPast, to: Date = .now) -> Int {
        var total = 0
        var count = 0
        
        for sleepSession in sleepSessions {
            let date = sleepSession.endDate
            guard date >= from && date <= to else { continue }
            
            total += Int(sleepSession.duration)
            count += 1
        }
        
        guard count > 0 else { return 0 }
                
        return total / count
    }
    
    /// Calculates the average sleep's starting hour within a given date range.
    /// - Parameters:
    ///   - from: The start date of the range. Defaults to `.distantPast`.
    ///   - to: The end date of the range. Defaults to `.now`.
    /// - Returns: The average starting hour (in minutes) of the sleep during the specified period.
    func averageStartHour(from: Date = .distantPast, to: Date = .now) -> Int {
        var total = 0
        var count = 0
        
        for sleepSession in sleepSessions {
            guard let start = sleepSession.startDate else { continue }
            guard start >= from && start <= to else { continue }
            
            let component = calendar.dateComponents([.hour, .minute], from: start)
            guard let hour = component.hour, let minute = component.minute else { continue }
            
            var minutes = (hour + 1) * 60 + minute
            if hour < 5 {
                minutes += 1440
            }
            
            total += minutes
            count += 1
        }
        
        guard count > 0 else { return 0 }
        
        return total / count
    }

    /// Calculates the average sleep's ending hour within a given date range.
    /// - Parameters:
    ///   - from: The start date of the range. Defaults to `.distantPast`.
    ///   - to: The end date of the range. Defaults to `.now`.
    /// - Returns: The average ending hour (in minutes) of the sleep during the specified period.
    func averageEndHour(from: Date = .distantPast, to: Date = .now) -> Int {
        var total = 0
        var count = 0
        
        for sleepSession in sleepSessions {
            guard let start = sleepSession.startDate else { continue }
            guard start >= from && start <= to else { continue }
            
            let component = calendar.dateComponents([.hour, .minute], from: sleepSession.endDate)
            guard let hour = component.hour, let minute = component.minute else { continue }
            total += (hour + 1) * 60 + minute
            count += 1
        }
        
        guard count > 0 else { return 0 }
        
        return total / count
    }
    
    /// Determines the trend in average sleep duration over the last week compared to previous data.
    /// - Returns: A string representing the trend:
    ///   - `"chevron.up"` if the average duration has increased significantly.
    ///   - `"chevron.down"` if the average duration has decreased significantly.
    ///   - `"minus"` if the change is not significant.
    func sleepTrend() -> String {
        let now = Date()
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: now)!

        let recent = averageSleep(from: lastWeek, to: now)
        let older = averageSleep(from: .distantPast, to: lastWeek)

        return compareTrend(recent: recent, older: older)
    }
    
    /// Determines the trend in average sleep starting hour over the last week compared to previous data.
    /// - Returns: A string representing the trend:
    ///   - `"chevron.up"` if the average starting hour has increased significantly.
    ///   - `"chevron.down"` if the average starting hour has decreased significantly.
    ///   - `"minus"` if the change is not significant.
    func hourStartTrend() -> String {
        let now = Date()
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        
        let recent = averageStartHour(from: lastWeek, to: now)
        let older = averageStartHour(from: .distantPast, to: lastWeek)

        return compareTrend(recent: recent, older: older)
    }
    
    /// Determines the trend in average sleep ending hour over the last week compared to previous data.
    /// - Returns: A string representing the trend:
    ///   - `"chevron.up"` if the average ending hour has increased significantly.
    ///   - `"chevron.down"` if the average ending hour has decreased significantly.
    ///   - `"minus"` if the change is not significant.
    func hourEndTrend() -> String {
        let now = Date()
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        
        let recent = averageEndHour(from: lastWeek, to: now)
        let older = averageEndHour(from: .distantPast, to: lastWeek)

        return compareTrend(recent: recent, older: older)
    }

    /// Compares two average and determines the direction of the trend.
    /// - Parameters:
    ///   - recent: The average in the recent period.
    ///   - older: The average in the older period.
    /// - Returns: A `SFSymbole` string indicating the trend direction.
    private func compareTrend(recent: Int, older: Int) -> String {
        let diff = recent - older
        let threshold = 30 // minutes

        if diff > threshold {
            return "chevron.up"
        } else if diff < -threshold {
            return "chevron.down"
        } else {
            return "minus"
        }
    }
}
