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

struct ContentView: View {
    @StateObject private var sleepVM = SleepHistoryViewModel()
    @StateObject private var exerciseVM = ExerciseListViewModel()
    @StateObject private var userVM = UserDataViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                // TODO allow user to reorganize ?
                VStack(spacing: 20) {
                    UserHeaderView(viewModel: userVM)
                    ExerciseSummaryCard(viewModel: exerciseVM)
                    CaloriesCard(calories: exerciseVM.calOfDay)
                    SleepSummaryCard(viewModel: sleepVM)
                    // TODO calcul trend on last 7 day and compare with other data ?
                    TrendsSection(exerciseVM: exerciseVM, sleepVM: sleepVM)
                }
                .padding(.horizontal)
            }
            .background(Color("DimGray").ignoresSafeArea())
        }
    }
}

#Preview {
    ContentView()
}
