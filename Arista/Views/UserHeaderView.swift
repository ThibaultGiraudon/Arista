//
//  UserHeaderView.swift
//  Arista
//
//  Created by Thibault Giraudon on 12/05/2025.
//

import SwiftUI

struct UserHeaderView: View {
    @ObservedObject var viewModel: UserDataViewModel

    var body: some View {
        NavigationLink {
            UserDataView(viewModel: viewModel)
        } label: {
            HStack {
                Spacer()
                Text(viewModel.initials)
                    .padding()
                    .foregroundStyle(.white)
                    .bold()
                    .background(Circle().fill(.gray))
            }
            .padding()
        }
    }
}

#Preview {
    UserHeaderView(viewModel: UserDataViewModel())
}
