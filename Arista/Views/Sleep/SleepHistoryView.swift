//
//  SleepHistoryView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI
import Charts

struct SleepHistoryView: View {
    @ObservedObject var viewModel: SleepHistoryViewModel
    @State private var selectedDate: Date?
    @State private var showSheet = false
    
    let calendar = Calendar.current

    var body: some View {
        VStack {
            Chart(viewModel.chartDatas, id: \.self) { data in
                BarMark(
                    x: .value("Jour", data.day, unit: .day),
                    yStart: .value("Heure de coucher", data.start),
                    yEnd: .value("Heure de réveil", data.end)
                )
                .foregroundStyle(.blue.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                if let selectedDate, let session = viewModel.getSleepSession(for: selectedDate) {
                    sleepAnnotation(for: session, on: selectedDate)
                }
            }
            .chartXSelection(value: $selectedDate)
            .gesture(gesture)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 1)) { value in
                    AxisValueLabel(format: .dateTime.day().month())
                }
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: .hour, count: 2)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.hour().minute())
                }
            }
            .chartYScale(domain: viewModel.yRange)
            .chartXScale(domain: viewModel.xRange)
            .padding()
            .frame(height: 400)
            Form {
                NavigationLink {
                    SleepSessionListView(viewModel: viewModel)
                } label: {
                    Text("Afficher toutes les données")
                }
                .listRowBackground(Color("OffWhite"))
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
        }
        .background {
            Color("DimGray")
                .ignoresSafeArea()
        }
        .foregroundStyle(Color("TextColor"))
        .navigationTitle("Sommeil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Ajouter des données") {
                    showSheet = true
                }
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: viewModel.fetchSleepSessions) {
            NavigationStack {
                AddSleepSessionView()
            }
        }
    }
    
    // MARK: - Gesture

    /// A gesture that allows the user to navigate between weeks.
    /// Swiping left advances to the next week, while swiping right goes back to the previous one.
    /// - Returns: A `Gesture` that updates the displayed week based on horizontal drag direction.
    var gesture: some Gesture {
        DragGesture()
            .onEnded { value in
                if value.translation.width < -50 {
                    self.moveToNextWeek()
                } else if value.translation.width > 50 {
                    self.moveToPreviousWeek()
                }
            }
    }
    
    /// Advances the current date by one week, unless it would result in a future date.
    /// This prevents navigating beyond the current week.
    private func moveToNextWeek() {
        guard let newDate = calendar.date(byAdding: .day, value: 7, to: viewModel.date) else { return }
        let today = calendar.startOfDay(for: Date())
        if calendar.startOfDay(for: newDate) <= today {
            viewModel.date = newDate
        }
    }

    /// Moves the date back by one week.
    private func moveToPreviousWeek() {
        guard let newDate = calendar.date(byAdding: .day, value: -7, to: viewModel.date) else { return }
        viewModel.date = newDate
    }
    
    // MARK: - Helper
    
    func sleepAnnotation(for session: Sleep, on date: Date) -> some ChartContent {
        RuleMark(x: .value("Date", date))
            .annotation(position: .trailing) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ENDORMI")
                    durationLabel(minutes: session.duration)
                    Text("QUALITÉ")
                    qualityLabel(score: session.quality)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .foregroundStyle(.gray)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary)
                }
            }
    }
    
    @ViewBuilder
    func durationLabel(minutes: Int64) -> some View {
        HStack(spacing: 2) {
            Text("\(minutes / 60)")
                .foregroundStyle(.white)
                .font(.title.bold())
            Text("h")
            Text("\(minutes % 60)")
                .foregroundStyle(.white)
                .font(.title.bold())
            Text("m")
        }
    }

    @ViewBuilder
    func qualityLabel(score: Int16) -> some View {
        HStack(spacing: 2) {
            Text("\(score)")
                .foregroundStyle(.white)
                .font(.title.bold())
            Text("/ 10")
        }
    }
}

#Preview {
//    NavigationStack {
        SleepHistoryView(viewModel: SleepHistoryViewModel(context: PersistenceController.shared.container.viewContext))
//    }
}
