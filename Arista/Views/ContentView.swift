//
//  ContentView.swift
//  Arista
//
//  Created by Thibault Giraudon on 11/05/2025.
//

import SwiftUI

extension View {
    func cardBackground(_ length: CGFloat = 20) -> some View {
        self
            .padding(length)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color("OffWhite"))
            }
            .foregroundStyle(Color("TextColor"))
    }
}

// TODO add comment in all project
// TODO create extension for ViewModels
// TODO moves extension in dedicated files
// TODO add unit test
struct ContentView: View {
    @StateObject private var sleepVM = SleepHistoryViewModel()
    @StateObject private var exerciseVM = ExerciseListViewModel()
    @StateObject private var userVM = UserDataViewModel()
    @StateObject private var appState = AppState.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // TODO save user when edited
                    UserHeaderView(viewModel: userVM)
                    // TODO let user delete exercise
                    ExerciseSummaryCard(viewModel: exerciseVM)
                    CaloriesCard(calories: exerciseVM.calOfDay)
                    // TODO let user delete sleep session
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
