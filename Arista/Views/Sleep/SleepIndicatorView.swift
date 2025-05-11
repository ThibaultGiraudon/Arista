//
//  SleepIndicatorView.swift
//  Arista
//
//  Created by Thibault Giraudon on 05/05/2025.
//

import SwiftUI

struct SleepIndicatorView: View {
    var duration: Int
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .frame(width: 50)
                .foregroundStyle(.gray.opacity(0.2))
            Circle()
                .trim(from: 0.0, to: CGFloat(Double(duration) / 12.0))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .fill(AngularGradient(gradient: gradient, center: .center, startAngle: .zero, endAngle: .init(degrees: 360.0 * CGFloat(Double(duration) / 12.0))))
                .frame(width: 50)
                .rotationEffect(Angle(degrees: 270.0))
            Text("\(duration)")
        }
    }
    
    var gradient: Gradient {
        switch duration {
            case 0...5:
                return .init(colors: [.red, .pink])
            case 6...7:
                return .init(colors: [.blue, .cyan])
            default:
                return .init(colors: [.green, .teal])
        }
    }
}

#Preview {
    SleepIndicatorView(duration: 5)
}
