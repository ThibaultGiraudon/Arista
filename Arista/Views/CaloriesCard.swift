//
//  CaloriesCard.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct CaloriesCard: View {
    let calories: Int

    var body: some View {
        VStack(alignment: .leading) {
            HeaderRow(icon: "flame.fill", title: "Calories", date: Date(), isNav: false)
                .foregroundStyle(.red)
            HStack {
                Text("\(calories)")
                    .font(.largeTitle.bold())
                Text("kcal")
            }
        }
        .cardBackground()
    }
}

#Preview {
    CaloriesCard(calories: 434)
}
