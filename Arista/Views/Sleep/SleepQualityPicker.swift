//
//  SleepQualityPicker.swift
//  Arista
//
//  Created by Thibault Giraudon on 08/05/2025.
//

import SwiftUI

struct SleepQualityPicker: View {
    @Binding var quality: Int
    let screenWidth = UIScreen.main.bounds.width
    @State private var width: CGFloat = 0.0
    @State private var initialWidth: CGFloat = 0.0
    
    var body: some View {
            VStack {
                GeometryReader { geo in
                    let totalWidth = geo.size.width - 40
                    let step = totalWidth / 10
                ZStack(alignment: .leading) {
                    // Gray background
                    Capsule()
                        .fill(.gray.opacity(0.2))
                    
                    // Quality indicator
                    Capsule()
                        .foregroundStyle(LinearGradient(colors: gradientColors(), startPoint: .leading, endPoint: .trailing))
                        .frame(width: currentWidth(for: totalWidth))
                    
                    // All values
                    HStack(spacing: 0) {
                        ForEach(0..<10, id: \.self) { index in
                            Circle()
                                .fill(.white)
                                .frame(width: 10)
                                .frame(width: step, alignment: .center)
                                .onTapGesture {
                                    withAnimation {
                                        quality = index + 1
                                        initialWidth = CGFloat(quality) * step
                                    }
                                }
                        }
                    }
                    
                }
                .clipShape (
                    Capsule()
                )
                .padding(.horizontal, 20)
                .gesture(
                    // Gesture allowing user to slide the cursor
                    DragGesture()
                        .onChanged { value in
                            width = value.translation.width
                            let total = initialWidth + width
                            let index = round(total / step)
                            quality = Int(min(max(index, 0), 10))
                        }
                        .onEnded { _ in
                            let total = initialWidth + width
                            let index = round(total / step)
                            quality = Int(min(max(index, 0), 10))
                            initialWidth = CGFloat(quality) * step
                            width = 0
                        }
                )
                .onAppear {
                    initialWidth = CGFloat(quality) * step
                }
                    
            }
        }
    }
    
    /// Returns the indicator width between 0 and the width of the view
    /// - Parameter for: the width of the view
    /// - Returns: a `CGFloat` representing the size of the indicator
    func currentWidth(for totalWidth: CGFloat) -> CGFloat {
        return min(max(initialWidth + width, 0), totalWidth)
    }
    
    /// Returns the gradient colors depending the quality
    /// - Returns: an Array of `Color` representig the quality
    func gradientColors() -> [Color] {
        let colors: [Color] = [.red, .orange, .yellow, .green.opacity(0.6), .green]
        let gradient = colors.prefix(Int(round(Double(quality) / 2.0)))
        return Array(gradient)
    }
}



#Preview {
    @Previewable @State var quality = 10
    SleepQualityPicker(quality: $quality)
        .frame(width: UIScreen.main.bounds.width, height: 30)
}
