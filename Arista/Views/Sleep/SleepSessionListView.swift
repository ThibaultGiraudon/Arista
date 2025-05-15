//
//  SleepSessionListView.swift
//  Arista
//
//  Created by Thibault Giraudon on 11/05/2025.
//

import SwiftUI

struct SleepSessionListView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel
    var body: some View {
        List {
            ForEach(viewModel.sortedSleepSessions, id: \.0) { key, sleeps in
                Section(getHeader(for: key)) {
                    ForEach(sleeps, id: \.self) { sleep in
                        HStack(spacing: 20) {
                            SleepIndicatorView(duration: Int(sleep.duration / 60), hoursSleep: Int(sleep.user?.hoursSleep ?? 8))
                            VStack(alignment: .leading) {
                                Text("Début: \(sleep.startDate?.formatted("dd MMMM HH:mm") ?? "")")
                                Text("Fin: \(sleep.endDate.formatted("dd MMMM HH:mm"))")
                            }
                            Spacer()
                            Text("\(sleep.quality)/10")
                                .font(.title3)
                        }
                    }
                    .onDelete { indexes in
                        let sleepToDelete = indexes.map { sleeps[$0] }
                        viewModel.deleteSleepSessions(sleepToDelete)
                    }
                }
            }
            .listRowBackground(Color("OffWhite"))
        }
        .scrollContentBackground(.hidden)
        .background {
            Color("DimGray")
                .ignoresSafeArea()
        }
        .foregroundStyle(Color("TextColor"))
    }
    
    func getHeader(for date: Date) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 3600)!
        var component = calendar.dateComponents([.day, .month, .year, .weekOfYear], from: date)
        component.year = 2025
        guard let newDate = calendar.date(from: component) else { return "" }
        let week = calendar.dateInterval(of: .weekOfYear, for: newDate)
        guard let week = week else { return "" }
        let firstDay = week.start
        let lastDay = week.end
        return "\(firstDay.formatted("d"))-\(lastDay.formatted("d")) \(lastDay.formatted("MMMM"))"
    }
    
}

#Preview {
    SleepSessionListView(viewModel: SleepHistoryViewModel())
}
