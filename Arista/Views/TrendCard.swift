//
//  TrendCard.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct TrendCard: View {
    let title: String
    let value: String
    let unit: String?
    let color: Color

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "minus")
                .padding(15)
                .font(.title.bold())
                .foregroundStyle(color)
                .background(Circle().fill(color.opacity(0.1)))
            VStack(alignment: .leading) {
                Text(title)
                HStack(spacing: 2) {
                    Text(value)
                        .font(.headline.bold())
                    if let unit = unit {
                        Text(unit)
                            .font(.subheadline.bold())
                    }
                }
                .foregroundStyle(color)
            }
        }
    }
}

#Preview {
    TrendCard(title: "M'entrainer", value: "29", unit: "MIN/JOUR", color: .green)
}
