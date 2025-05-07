//
//  Sleep.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

class Sleep: NSManagedObject {
    var endDate: Date {
        startDate?.addingTimeInterval(Double(duration * 60)) ?? .now
    }
}
