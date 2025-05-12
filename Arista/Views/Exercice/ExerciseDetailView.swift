//
//  ExerciseDetailView.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct ExerciseDetailView: View {
    var exercise: Exercice
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: exercise.categoryItem.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                        .background {
                            Circle()
                                .fill(.gray.opacity(0.2))
                        }
                    VStack(alignment: .leading) {
                        Text(exercise.categoryItem.rawValue)
                            .font(.title)
                        Text(timeRange(for: exercise.date))
                    }
                    Spacer()
                }
                Group {
                    Text("Detail de l'exercice")
                        .font(.title.bold())
                    HStack {
                        detailLabel(title: "Durée", value: "\(exercise.duration / 60):\(exercise.duration % 60):00", color: .yellow)
                        Spacer()
                        detailLabel(title: "Kcal en activité", value: "\(exercise.calories)", unit: "KCAL", color: .red)
                    }
                    .cardBackground()
                }
                .padding(.top)
                VStack(alignment: .leading, spacing: 0) {
                    Text("Effort")
                        .font(.title2)
                    IntensityRowView(intensity: Int(exercise.intensity))
                }
                .cardBackground()
            }
        }
        .padding()
        .foregroundStyle(Color("TextColor"))
        .background {
            Color("DimGray")
                .ignoresSafeArea()
        }
        .navigationTitle(exercise.date?.formatted("EEE dd MMMM") ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var currentColor: Color {
        switch exercise.intensity {
            case 1:
                return Color(60, 113, 85)
            case 2:
                return Color(54, 116, 108)
            case 3:
                return Color(47, 100, 120)
            case 4:
                return Color(66, 98, 137)
            case 5:
                return Color(51, 62, 87)
            case 6:
                return Color(75, 63, 137)
            case 7:
                return Color(100, 70, 137)
            case 8:
                return Color(108, 62, 138)
            case 9:
                return Color(132, 70, 126)
            default:
                return Color(130, 60, 102)
        }
    }
    
    func timeRange(for date: Date?) -> String {
        guard let startDate = date else { return "" }
        let endDate = startDate.addingTimeInterval(Double(exercise.duration) * 60)
        return "\(startDate.formatted("hh:mm"))-\(endDate.formatted("hh:mm"))"
    }
    
    @ViewBuilder
    func detailLabel(title: String, value: String, unit: String = "", color: Color) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
            HStack(alignment: .bottom) {
                Text(value)
                    .font(.largeTitle.bold())
                Text(unit)
                    .font(.title)
            }
            .foregroundStyle(color)
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: ExerciseListViewModel().exercises.first!)
    }
}
