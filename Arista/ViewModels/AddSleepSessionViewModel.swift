//
//  AddSleepSessionViewModel.swift
//  Arista
//
//  Created by Thibault Giraudon on 05/05/2025.
//

import Foundation

class AddSleepSessionViewModel: ObservableObject {
    @Published var quality = 5
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now {
        didSet {
            updateDuration()
        }
    }
    
    let appState = AppState.shared
    
    var duration = 0
    
    var repository = SleepRepository()
    
    func addSleepSession() {
        do {
            try repository.addSleep(duration: duration, quality: quality, startDate: startDate)
        } catch {
            appState.reportError("Error fetching adding sleep session: \(error.localizedDescription)")
        }
    }
    
    private func updateDuration() {
        let timeInterval = endDate.timeIntervalSince(startDate)
        let newDuration = Int(timeInterval / 60)
        duration = newDuration
    }
}
