//
//  Array+interpolateColors.swift
//  Arista
//
//  Created by Thibault Giraudon on 04/05/2025.
//

import Foundation
import SwiftUI

extension Array<Color> {
    static func interpolateColors(from start: (Int, Int, Int), to end: (Int, Int, Int), steps: Int) -> [Color] {
        (0..<steps).map { i in
            let t = Double(i) / Double(steps - 1)
            let r = Double(start.0) + (Double(end.0) - Double(start.0)) * t
            let g = Double(start.1) + (Double(end.1) - Double(start.1)) * t
            let b = Double(start.2) + (Double(end.2) - Double(start.2)) * t
            return Color(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
        }
    }
}
