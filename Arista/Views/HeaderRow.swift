//
//  HeaderRow.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct HeaderRow: View {
    let icon: String
    let title: String
    let date: Date?
    let isNav: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
            Text(date?.formatted("d MMMM") ?? "")
                .foregroundStyle(.gray)
            if isNav {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
                    .font(.footnote)
            }
        }
        .font(.title2)
    }
}

#Preview {
    HeaderRow(icon: "flame", title: "Calorie", date: .now, isNav: true)
}
