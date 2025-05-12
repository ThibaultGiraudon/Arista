//
//  Exercice.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

class Exercice: NSManagedObject {
    var categoryItem: Category {
        for item in Category.allCases {
            if item.rawValue == self.category {
                return item
            }
        }
        return .other
    }
    
    var calories: Int {
        let durationHour: Double = Double(self.duration) / 60.0
        return Int(self.categoryItem.met * durationHour * (self.user?.weight ?? 75.0))
    }
}
