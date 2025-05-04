//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData
import SwiftUI

extension Array<Color> {
    func interpolateColors(from start: (Int, Int, Int), to end: (Int, Int, Int), steps: Int) -> [Color] {
        (0..<steps).map { i in
            let t = Double(i) / Double(steps - 1)
            let r = Double(start.0) + (Double(end.0) - Double(start.0)) * t
            let g = Double(start.1) + (Double(end.1) - Double(start.1)) * t
            let b = Double(start.2) + (Double(end.2) - Double(start.2)) * t
            return Color(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
        }
    }
}

class AddExerciseViewModel: ObservableObject {
    @Published var category: String = ""
    @Published var date: Date = Date.now
    @Published var duration: Int = 0
    @Published var intensity: Int = 8
    let colorGradients: [[Color]] = [
        interpolateColors(from: (60, 113, 85), to: (20, 35, 34), steps: 10),
        interpolateColors(from: (54, 116, 108), to: (21, 33, 38), steps: 10),
        interpolateColors(from: (47, 100, 120), to: (21, 30, 38), steps: 10),
        interpolateColors(from: (66, 98, 137), to: (21, 23, 45), steps: 10),
        interpolateColors(from: (51, 62, 87), to: (19, 15, 37), steps: 10),
        interpolateColors(from: (75, 63, 137), to: (29, 20, 46), steps: 10),
        interpolateColors(from: (100, 70, 137), to: (45, 17, 63), steps: 10),
        interpolateColors(from: (108, 62, 138), to: (47, 16, 57), steps: 10),
        interpolateColors(from: (132, 70, 126), to: (57, 16, 40), steps: 10),
        interpolateColors(from: (130, 60, 102), to: (57, 17, 29), steps: 10)
    ]
    

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
    }

    func addExercise() -> Bool {
        do {
            try ExerciceRepository().addExercice(category: category, date: date, intensity: intensity, duration: duration)
            return true
        } catch {
            return false
        }
    }
    
    var currentColor: Color {
        switch intensity {
            case 1:
                return Color(60, 113, 85)
            case 2:
                return Color(54, 116, 108)
            case 3:
                return Color(47, 100, 120)
            case 4:
                return Color(66, 98, 137)
            case 5:
                return Color(51, 62, 87)
            case 6:
                return Color(75, 63, 137)
            case 7:
                return Color(100, 70, 137)
            case 8:
                return Color(108, 62, 138)
            case 9:
                return Color(132, 70, 126)
            default:
                return .yellow
//                return Color(130, 60, 102)
        }
    }
    
}
