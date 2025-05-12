//
//  SleepSummaryCard.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct SleepSummaryCard: View {
    @ObservedObject var viewModel: SleepHistoryViewModel

    var body: some View {
        NavigationLink {
            SleepHistoryView(viewModel: viewModel)
        } label: {
            VStack(alignment: .leading) {
                let lastSleep = viewModel.sleepSessions.last ?? Sleep()

                HeaderRow(icon: "bed.double.fill", title: "Sommeil", date: lastSleep.endDate, isNav: true)
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

#Preview {
    SleepSummaryCard(viewModel: SleepHistoryViewModel())
}
