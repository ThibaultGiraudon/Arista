//
//  AddSleepSessionViewModel.swift
//  Arista
//
//  Created by Thibault Giraudon on 05/05/2025.
//

import Foundation
import CoreData

class AddSleepSessionViewModel: ObservableObject {
    @Published var quality = 5
    @Published var startDate: Date = .now
    /// Calculates the duration from the sleep's ending hour.
    @Published var endDate: Date = .now {
        didSet {
            updateDuration()
        }
    }
    var duration = 0
    
    /// Shared struct catching error thrown
    let appState = AppState.shared
    
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    /// Add new session in the repository.
    func addSleepSession() {
        do {
            try SleepRepository(viewContext: viewContext).addSleep(duration: duration, quality: quality, startDate: startDate)
        } catch {
            appState.reportError("Error adding sleep session: \(error.localizedDescription)")
        }
    }
    
    /// Updates duration with the starting and ending dates
    private func updateDuration() {
        let timeInterval = endDate.timeIntervalSince(startDate)
        let newDuration = Int(timeInterval / 60)
        duration = newDuration
    }
}
