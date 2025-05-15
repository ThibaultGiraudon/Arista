//
//  Date+formatted.swift
//  Arista
//
//  Created by Thibault Giraudon on 15/05/2025.
//

import Foundation

extension Date {
    func formatted(_ formatStyle: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr")
        formatter.dateFormat = formatStyle
        return formatter.string(from: self)
    }
}
