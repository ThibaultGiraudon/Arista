//
//  IntensityPickerView.swift
//  Arista
//
//  Created by Thibault Giraudon on 04/05/2025.
//

import SwiftUI

func interpolateColors(from start: (Int, Int, Int), to end: (Int, Int, Int), steps: Int) -> [Color] {
    (0..<steps).map { i in
        let t = Double(i) / Double(steps - 1)
        let r = Double(start.0) + (Double(end.0) - Double(start.0)) * t
        let g = Double(start.1) + (Double(end.1) - Double(start.1)) * t
        let b = Double(start.2) + (Double(end.2) - Double(start.2)) * t
        return Color(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
    }
}

struct IntensityPickerView: View {
    @ObservedObject var viewModel: AddExerciseViewModel
    @State private var lastHapticIntensity: Int = 5
    @GestureState private var dragOffsetX: CGFloat = 0.0

    let barWidth: CGFloat = 30
    let spacing: CGFloat = 5
    let totalBars = 10

    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            // Background Color
            LinearGradient(colors: viewModel.colorGradients[currentIntensity(for: dragOffsetX) - 1], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ZStack(alignment: .bottomLeading) {
                // Different intensity available
                HStack(alignment: .bottom, spacing: spacing) {
                    ForEach(1...totalBars, id: \.self) { value in
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: barWidth, height: CGFloat(value * 15))
                            .foregroundStyle(.secondary)
                            .onTapGesture {
                                hapticFeedback(with: viewModel.intensity)
                                withAnimation {
                                    viewModel.intensity = value
                                }
                            }
                    }
                }

                // Current dragable Intensity
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: barWidth, height: CGFloat(currentIntensity(for: dragOffsetX) * 15))
                    .offset(x: xOffset(for: dragOffsetX), y: 0)
                    .foregroundStyle(.white)
                    
            }
            .gesture(
                DragGesture()
                    .updating($dragOffsetX) { value, state, _ in
                        state = value.translation.width
                        let current = currentIntensity(for: value.translation.width)
                            if current != lastHapticIntensity {
                                lastHapticIntensity = current

                                hapticFeedback(with: current)
                            }
                    }
                    .onEnded { value in
                        let new = currentIntensity(for: value.translation.width)
                        let clamped = min(max(new, 1), totalBars)

                        hapticFeedback(with: clamped)
                        
                        viewModel.intensity = clamped
                    }
            )
            .padding(.horizontal)
        }
    }

    // Calculate currentIntensity during dragGesture
    private func currentIntensity(for offset: CGFloat) -> Int {
        let xPos = xOffset(for: offset)
        let rawIndex = Int(round(xPos / (barWidth + spacing))) + 1
        return min(max(rawIndex, 1), totalBars)
    }

    // Calcuate intensity position
    private func xOffset(for offset: CGFloat) -> CGFloat {
        CGFloat(viewModel.intensity - 1) * (barWidth + spacing) + offset
    }
    
    // Activate haptic feedback
    private func hapticFeedback(with value: Int) {
        let style: UIImpactFeedbackGenerator.FeedbackStyle = {
            switch value {
            case 1...3: return .light
            case 4...7: return .medium
            default: return .heavy
            }
        }()
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

#Preview {
    IntensityPickerView(viewModel: AddExerciseViewModel())
}
