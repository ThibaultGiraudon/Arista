//
//  View+cardBackground.swift
//  Arista
//
//  Created by Thibault Giraudon on 15/05/2025.
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
