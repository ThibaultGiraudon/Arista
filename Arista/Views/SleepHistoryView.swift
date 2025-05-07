//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import Charts

func sleepYAxisBounds() -> (lower: Date, upper: Date) {
    let calendar = Calendar.current
    let baseDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1))!
    
    let lower = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: baseDate)!
    let upper = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: baseDate.addingTimeInterval(86400))! // +1 jour

    return (lower, upper)
}

struct SleepHistoryView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel
    @State private var date = Date()
    let bounds = sleepYAxisBounds()

    var body: some View {
        VStack {
            Chart {
                ForEach(generateDaysInWeek(for: date), id: \.self) { day in
                    let session = viewModel.getSleepSession(for: day)
                    let start = normalizeToReferenceDay(session.start)
                    let end = normalizeToReferenceDay(session.end)
                        
                    BarMark(
                        x: .value("Jour", day, unit: .day),
                        yStart: .value("Heure de coucher", start),
                        yEnd: .value("Heure de réveil", end)
                    )
                    .foregroundStyle(.blue.opacity(0.6)) 
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                }
            }
            .chartYScale(domain: bounds.lower...bounds.upper)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 1)) { value in
                    AxisValueLabel(format: .dateTime.day())
                }
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: .hour, count: 2)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.hour().minute())
                }
            }
            .padding()
        }
        .padding()
        .navigationTitle("Historique de Sommeil")
    }
    
    func normalizeToReferenceDay(_ date: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: -3600)!

        let components = calendar.dateComponents([.hour, .minute, .second], from: date)

        var baseDate = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2000,
            month: 1,
            day: 1,
            hour: components.hour,
            minute: components.minute,
            second: components.second
        )
        
        if let hour = components.hour, hour < 12 {
            baseDate.day! += 1
        }

        return calendar.date(from: baseDate)!
    }
    
    func generateDaysInWeek(for date: Date) -> [Date] {
        var days: [Date] = []
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: date) else { return days }
        
        var currentDate = weekInterval.start
        while currentDate + 86400 < weekInterval.end + 86400 {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
}

#Preview {
    SleepHistoryView(viewModel: SleepHistoryViewModel(context: PersistenceController.preview.container.viewContext))
}
