//
//  IntensityViewq.swift
//  Arista
//
//  Created by Thibault Giraudon on 04/05/2025.
//

import SwiftUI

struct IntensityView: View {
    var intensity: Int
    
    let barWidth: CGFloat = 7
    let spacing: CGFloat = 5
    let totalBars = 5
    var body: some View {
        HStack(alignment: .bottom, spacing: spacing) {
            ForEach(0...totalBars, id: \.self) { value in
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: barWidth, height: CGFloat(value) * 7)
                    .foregroundStyle(value == Int(round(Double(intensity) / 2.0)) ? color() : .secondary)
            }
        }
    }
    
    func color() -> Color {
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
                return Color(130, 60, 102)
        }
    }
}

#Preview {
    IntensityView(intensity: 10)
}
