//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct UserDataView: View {
    @ObservedObject var viewModel: UserDataViewModel
    
    let sleepValue: [Int] = stride(from: 6, to: 14, by: 1).map { $0 }

    var body: some View {
        Form {
            HStack {
                Text(viewModel.initials)
                    .font(.title)
                    .padding()
                    .foregroundStyle(.white)
                    .background {
                        Circle()
                            .fill(.gray)
                    }
                VStack {
                    TextField("Nom", text: $viewModel.name)
                        .font(.title3.bold())
                    TextField("Email", text: $viewModel.email)
                }
            }
            .listRowBackground(Color("OffWhite"))
            Section("Renseignements") {
                HStack {
                    Text("Poid (kg)")
                    TextField("", value: Binding(
                        get: { viewModel.weight },
                        set: { value in
                            if value > 230 {
                                viewModel.weight = 230
                            }
                            else if value < 30 {
                                viewModel.weight = 30
                            }
                            else {
                                viewModel.weight = value
                            }
                        }
                    ), format: .number)
                    .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Taille (cm)")
                    TextField("", value: Binding(
                        get: { viewModel.size },
                        set: { value in
                            if value > 250 {
                                viewModel.size = 250
                            }
                            else if value < 100 {
                                viewModel.size = 100
                            }
                            else {
                                viewModel.size = value
                            }
                        }), format: .number)
                    .multilineTextAlignment(.trailing)
                }
                Picker("Heures de repos", selection: $viewModel.hoursSleep) {
                    ForEach(sleepValue, id: \.self) { sleep in
                        Text("\(sleep)h")
                    }
                }
            }
            .listRowBackground(Color("OffWhite"))
        }
        .foregroundStyle(Color("TextColor"))
        .scrollContentBackground(.hidden)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.saveUser()
                }
                .disabled(viewModel.shouldDisable)
            }
        }
        .background {
            Color("DimGray")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        UserDataView(viewModel: UserDataViewModel())
    }
}
