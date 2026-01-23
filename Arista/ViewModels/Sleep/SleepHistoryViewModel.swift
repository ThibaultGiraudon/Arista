//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData
import SwiftUI

struct ChartSleepData: Identifiable, Hashable {
    let id = UUID()
    let day: Date
    let start: Date
    let end: Date
}

class SleepHistoryViewModel: ObservableObject {
    /// All sleep sessions from CoreData.
    @Published var sleepSessions = [Sleep]()
    /// All sleep sessions grouped by weeks.
    @Published var mappedSessions = [Date: [Sleep]]()
    /// All sleep sessions grouped by weeks and sorted ascending.
    var sortedSleepSessions: [(Date, [Sleep])] {
        mappedSessions.map { key, sleeps in
            let sortedSleeps = sleeps.sorted(by: {
                $0.endDate > $1.endDate
            })
            return (key, sortedSleeps)
        }.sorted(by: { $0.0 > $1.0 })
    }
    /// The date from which displays data in chart.
    @Published var date = Date.now
    
    /// Shared struct catching error thrown.
    let appState = AppState.shared
    
    /// Current calendar used to work with date.
    var calendar: Calendar
    /// Local time zone (France).
    let timeZone: TimeZone
    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        self.calendar = Calendar.current
        self.timeZone = TimeZone(secondsFromGMT: 3600)! // France
        calendar.timeZone = timeZone
        fetchSleepSessions()
    }

    // MARK: - Public API

    /// Returns the start and end time of a sleep session for a given day, if available.
    /// - Parameter day: The date for which to retrieve the sleep session.
    /// - Returns: A tuple containing the start and end `Date` of the sleep session, or `nil` if none is found.
    func getSleep(for day: Date) -> (start: Date, end: Date) {
        guard let session = getSleepSession(for: day),
              let start = session.startDate else { return (.now, .now) }
        return (start, session.endDate)
    }

    /// Fetches a sleep session for a given date.
    /// The session is considered to belong to the day if its start time falls between 8:00 PM and 10:00 AM of the next day.
    /// - Parameter date: The date for which to fetch the sleep session.
    /// - Returns: A `Sleep` object if a session is found, otherwise `nil`.
    func getSleepSession(for date: Date) -> Sleep? {
        // date = jour de réveil
        let dayStart = calendar.startOfDay(for: date)
        
        guard let lowerBound = calendar.date(byAdding: .hour, value: -4, to: dayStart),
              let upperBound = calendar.date(byAdding: .hour, value: 10, to: dayStart) else {
            return nil
        }

        return sleepSessions.first {
            guard let start = $0.startDate else { return false }
            return start >= lowerBound && start < upperBound
        }
    }
    
    /// Deletes all given sleep sessions and fetches back all sessions remaining.
    /// - Parameter sleepToDelete: An array of `Sleep` that should be deleted.
    func deleteSleepSessions(_ sleepsToDelete: [Sleep]) {
        for sleep in sleepsToDelete {
            viewContext.delete(sleep)
        }
        
        do {
            try viewContext.save()
            fetchSleepSessions()
        } catch {
            appState.reportError("Error deleting sleep session: \(error.localizedDescription)")
        }
    }
    
    /// Loads all sleep sessions from the repository and updates the local state.
    func fetchSleepSessions() {
        do {
            sleepSessions = try SleepRepository(viewContext: viewContext).getSleepSessions()
            mapSleepSessions()
        } catch {
            appState.reportError("Error fetching sleep sessions: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helper
    
    /// Groupes all sessions by weeks from sleepSessions and updates the local state.
    private func mapSleepSessions() {
        mappedSessions = Dictionary(grouping: sleepSessions) { sleep -> Date in
            let startComponents = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: sleep.endDate)

            if let date = Calendar.current.date(from: startComponents) {
                return date
            }
            return .now
        }
    }
}
