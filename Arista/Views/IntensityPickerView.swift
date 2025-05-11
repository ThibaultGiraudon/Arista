//
//  IntensityPickerView.swift
//  Arista
//
//  Created by Thibault Giraudon on 04/05/2025.
//

import SwiftUI

struct IntensityPickerView: View {
    @ObservedObject var viewModel: AddExerciseViewModel
    @State private var lastHapticIntensity: Int = 5
    @GestureState private var dragOffsetX: CGFloat = 0.0
    @Environment(\.dismiss) var dismiss

    let barWidth: CGFloat = 30
    let spacing: CGFloat = 5
    let totalBars = 10

    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            // Background Color
            LinearGradient(colors: viewModel.colorGradients[currentIntensity(for: dragOffsetX) - 1], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Évaluez votre effort")
                    .font(.title.bold())
                ZStack(alignment: .bottomLeading) {
                    // Different intensity available
                    HStack(alignment: .bottom, spacing: spacing) {
                        ForEach(1...totalBars, id: \.self) { value in
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: barWidth, height: CGFloat(value * 15))
                                .foregroundStyle(.white.opacity(0.2))
                                .onTapGesture {
                                    hapticFeedback(with: viewModel.currentIntensity)
                                    withAnimation {
                                        viewModel.currentIntensity = value
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
                            
                            viewModel.currentIntensity = clamped
                        }
                )
                .padding()
                HStack {
                    Text("\(currentIntensity(for: dragOffsetX))")
                        .padding()
                        .background {
                            Circle()
                                .foregroundStyle(.white.opacity(0.2))
                        }
                    Text(viewModel.effort(for: currentIntensity(for: dragOffsetX)))
                    Spacer()
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 20)
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.white.opacity(0.2))
                }
                .padding()
            }
            .foregroundStyle(.white)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Annuler") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Mettre a jour") {
                    viewModel.intensity = viewModel.currentIntensity
                    dismiss()
                }
            }
        }
    }

    /// Calculate intensity during dragGesture
    /// - Parameter for: the DragGesture offset
    /// - Returns: an `Int` representing the quality
    private func currentIntensity(for offset: CGFloat = 0.0) -> Int {
        let xPos = xOffset(for: offset)
        let rawIndex = Int(round(xPos / (barWidth + spacing))) + 1
        return min(max(rawIndex, 1), totalBars)
    }

    /// Calcuate the offset to place the bar
    /// - Parameter for: the DragGesture offset
    /// - Returns: a `CGFloat` to place the bar on the right place
    private func xOffset(for offset: CGFloat) -> CGFloat {
        CGFloat(viewModel.currentIntensity - 1) * (barWidth + spacing) + offset
    }
    
    /// Activate different haptic style depending on the quality
    /// - Parameter with: the current quality
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
