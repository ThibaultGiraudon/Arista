//
//  ContentView.swift
//  Arista
//
//  Created by Thibault Giraudon on 11/05/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var sleepVM = SleepHistoryViewModel()
    @StateObject private var exerciseVM = ExerciseListViewModel()
    @StateObject private var userVM = UserDataViewModel()
    @StateObject private var appState = AppState.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    UserHeaderView(viewModel: userVM)
                    ExerciseSummaryCard(viewModel: exerciseVM)
                    CaloriesCard(calories: exerciseVM.calOfDay)
                    SleepSummaryCard(viewModel: sleepVM)
                    TrendsSection(exerciseVM: exerciseVM, sleepVM: sleepVM)
                }
                .padding(.horizontal)
            }
            .background(Color("DimGray").ignoresSafeArea())
            .alert(appState.alertTitle, isPresented: $appState.showError) {
                Button("OK") { }
            }
        }
    }
}

#Preview {
    ContentView()
}
