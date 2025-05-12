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
                TrendCard(title: "M'entraîner", value: "\(exerciseVM.averageDuration)", unit: "MIN/JOUR", color: .green)
                TrendCard(title: "Dormir", value: "\(sleepVM.averageSleep)", unit: "H/JOUR", color: .blue)
                TrendCard(title: "Se coucher", value: "\(sleepVM.averageStartHour / 60)h\(sleepVM.averageStartHour % 60)", unit: nil, color: .indigo)
                TrendCard(title: "Se lever", value: "\(sleepVM.averageEndHour / 60)h\(sleepVM.averageEndHour % 60)", unit: nil, color: .purple)
            }
        }
        .cardBackground()
    }
}