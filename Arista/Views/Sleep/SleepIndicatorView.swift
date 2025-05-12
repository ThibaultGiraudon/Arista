//
//  SleepIndicatorView.swift
//  Arista
//
//  Created by Thibault Giraudon on 05/05/2025.
//

import SwiftUI

struct SleepIndicatorView: View {
    var duration: Int
    var hoursSleep: Int
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .frame(width: 50)
                .foregroundStyle(.gray.opacity(0.2))
            Circle()
                .trim(from: 0.0, to: CGFloat(Double(duration) / Double(hoursSleep)))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .fill(AngularGradient(gradient: gradient, center: .center, startAngle: .zero, endAngle: .init(degrees: 360.0 * CGFloat(Double(duration) / Double(hoursSleep)))))
                .frame(width: 50)
                .rotationEffect(Angle(degrees: 270.0))
            Text("\(duration)")
        }
    }
    
    var gradient: Gradient {
        switch duration {
            case 0...(hoursSleep * 1/3):
                return .init(colors: [.red, .pink])
            case (hoursSleep * 1/3)...(hoursSleep * 2/3):
                return .init(colors: [.blue, .cyan])
            case (hoursSleep * 2/3)...(hoursSleep + 1):
                return .init(colors: [.green, .teal])
            default:
                return .init(colors: [.red, .pink])
        }
    }
}

#Preview {
    SleepIndicatorView(duration: 8, hoursSleep: 12)
}
