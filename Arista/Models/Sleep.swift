//
//  Sleep.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

class Sleep: NSManagedObject {
    /// Calculates the sleep's ending hour from the starting hour and the duration.
    var endDate: Date {
        startDate?.addingTimeInterval(Double(duration * 60)) ?? .now
    }
}
