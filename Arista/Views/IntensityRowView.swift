//
//  IntensityRowView.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct IntensityRowView: View {
    var intensity: Int
    
    let barWidth: CGFloat = 7
    let spacing: CGFloat = 5
    let totalBars = 5
    var body: some View {
        HStack {
            Text("\(intensity)")
                .foregroundStyle(color())
                .font(.title.bold())
                .padding(10)
                .background {
                    Circle()
                        .fill(color().opacity(0.3))
                }
            Text(effort(for: intensity))
                .foregroundStyle(color())
                .font(.largeTitle)
            Spacer()
            IntensityView(intensity: intensity)
        }
    }
    
    func effort(for value: Int) -> String {
        switch value {
            case 1...3:
                return "Facile"
            case 4...6:
                return "Modéré"
            case 7...8:
                return "Difficile"
            default:
                return "Maximum"
        }
    }
    
    func color() -> Color {
        switch intensity {
            case 1:
                return Color(105, 201, 142)
            case 2:
                return Color(96, 208, 188)
            case 3:
                return Color(81, 177, 211)
            case 4:
                return Color(109, 172, 249)
            case 5:
                return Color(78, 90, 230)
            case 6:
                return Color(125, 100, 247)
            case 7:
                return Color(175, 116, 248)
            case 8:
                return Color(191, 98, 248)
            case 9:
                return Color(239, 117, 225)
            default:
                return Color(237, 98, 178)
        }
    }

}

#Preview {
    IntensityRowView(intensity: 5)
}
