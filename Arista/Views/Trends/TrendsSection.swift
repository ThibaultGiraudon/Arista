//
//  TrendsSection.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

extension Int {
    var formattedHoursMinutes: String {
        let hours = self / 60
        let minutes = self % 60
        return String(format: "%dH%02d", hours, minutes)
    }
}

struct TrendsSection: View {
    @ObservedObject var exerciseVM: ExerciseListViewModel
    @ObservedObject var sleepVM: SleepHistoryViewModel

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
                TrendCard(title: "Se coucher", value: sleepVM.averageStartHour().formattedHoursMinutes, unit: nil, color: .indigo, icon: sleepVM.hourStartTrend())
                TrendCard(title: "Se lever", value: sleepVM.averageEndHour().formattedHoursMinutes, unit: nil, color: .purple, icon: sleepVM.hourEndTrend())
            }
        }
        .cardBackground()
        .onAppear {
            print(exerciseVM.exercises)
            print(exerciseVM.averageDuration())
            print("-------------")
            print(sleepVM.sleepSessions)
            print(sleepVM.averageSleep())
            print(sleepVM.averageEndHour())
            print(sleepVM.averageStartHour())
        }
    }
}

#Preview {
    TrendsSection(exerciseVM: ExerciseListViewModel(), sleepVM: SleepHistoryViewModel())
}
