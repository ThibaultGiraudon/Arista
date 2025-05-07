//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class SleepHistoryViewModel: ObservableObject {
    @Published var sleepSessions = [Sleep]()
    
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchSleepSessions()
    }
    
    private func fetchSleepSessions() {
        do {
            sleepSessions = try SleepRepository().getSleepSessions()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getSleepSession(for day: Date) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let session = sleepSessions.first {
            let endDay = calendar.startOfDay(for: $0.endDate)
            let dayStripped = calendar.startOfDay(for: day)
            return endDay == dayStripped
        }
        print(session?.startDate ?? day, session?.endDate ?? day)
        return (session?.startDate ?? day, session?.endDate ?? day)
    }
}
