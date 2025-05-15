//
//  Exercice.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

class Exercice: NSManagedObject {
    /// Computes the `Category` from the `String` category
    var categoryItem: Category {
        for item in Category.allCases {
            if item.rawValue == self.category {
                return item
            }
        }
        return .other
    }
    
    /// Calculates the calories burned
    var calories: Int {
        let durationHour: Double = Double(self.duration) / 60.0
        return Int(self.categoryItem.met * durationHour * (self.user?.weight ?? 75.0))
    }
}
