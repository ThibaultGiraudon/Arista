struct SleepSummaryCard: View {
    @ObservedObject var viewModel: SleepHistoryViewModel

    var body: some View {
        NavigationLink {
            SleepHistoryView(viewModel: viewModel)
        } label: {
            VStack(alignment: .leading) {
                let lastSleep = viewModel.sleepSessions.last ?? Sleep()

                HeaderRow(icon: "bed.double.fill", title: "Sommeil", date: lastSleep.endDate)
                    .foregroundStyle(.teal)

                Text("Durée")
                HStack {
                    Text("\(lastSleep.duration / 60)").font(.title.bold())
                    Text("h")
                    Text("\(lastSleep.duration % 60)").font(.title.bold())
                    Text("min")
                }
            }
            .cardBackground()
        }
    }
}