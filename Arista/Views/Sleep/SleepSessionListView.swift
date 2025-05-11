//
//  SleepSessionListView.swift
//  Arista
//
//  Created by Thibault Giraudon on 11/05/2025.
//

import SwiftUI

extension Date {
    func formatted(_ formatStyle: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr")
        formatter.dateFormat = formatStyle
        return formatter.string(from: self)
    }
}

struct SleepSessionListView: View {
    var sleepSessions: [Date: [Sleep]]
    var body: some View {
        Form {
            ForEach(sleepSessions.sorted(by: { $0.key > $1.key }), id: \.key) { (key, sleeps) in
                Section(getHeader(for: key)) {
                    ForEach(sleeps, id: \.self) { sleep in
                        HStack(spacing: 20) {
                            SleepIndicatorView(duration: Int(sleep.duration / 60))
                            VStack(alignment: .leading) {
                                Text("Début: \(sleep.startDate ?? .now, format: .dateTime.hour().minute())")
                                Text("Fin: \(sleep.endDate, format: .dateTime.hour().minute())")
                            }
                            Spacer()
                            Text("\(sleep.quality)/10")
                                .font(.title)
                        }
                    }
                }
            }
        }
    }
    
    func getHeader(for date: Date) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 3600)!
        let component = calendar.dateComponents([.day, .month], from: date)
        guard let day = component.day else {
            return ""
        }
        return "\(day)-\(day + 1) \(date.formatted("MMMM"))"
    }
    
}

#Preview {
    SleepSessionListView(sleepSessions: SleepHistoryViewModel.shared.mappedSessions)
}
