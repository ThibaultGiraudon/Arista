//
//  TrendsSection.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct TrendsSection: View {
    let exerciseVM: ExerciseListViewModel
    let sleepVM: SleepHistoryViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                Text("Tendance")
                Spacer()
            }
            .font(.title2)
            .foregroundStyle(.green)

            LazyVGrid(columns: Array(repeating: .init(), count: 2), alignment: .leading) {
                TrendCard(title: "M'entraîner", value: "\(exerciseVM.averageDuration())", unit: "MIN/JOUR", color: .green, icon: exerciseVM.durationTrend())
                TrendCard(title: "Dormir", value: "\(sleepVM.averageSleep() / 60)", unit: "H/JOUR", color: .blue, icon: sleepVM.sleepTrend())
                TrendCard(title: "Se coucher", value: "\(sleepVM.averageStartHour() / 60 % 24)h\(sleepVM.averageStartHour() % 60)", unit: nil, color: .indigo, icon: sleepVM.hourStartTrend())
                TrendCard(title: "Se lever", value: "\(sleepVM.averageEndHour() / 60)h\(sleepVM.averageEndHour() % 60)", unit: nil, color: .purple, icon: sleepVM.hourEndTrend())
            }
        }
        .cardBackground()
    }
}

#Preview {
    TrendsSection(exerciseVM: ExerciseListViewModel(), sleepVM: SleepHistoryViewModel())
}
