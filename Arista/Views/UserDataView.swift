//
//  UserDataView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct UserDataView: View {
    @ObservedObject var viewModel: UserDataViewModel
    let weightValues: [Double] = stride(from: 30.0, through: 150, by: 0.5).map { Double(round(100*$0)/100) }
    let sizeValues: [Int] = stride(from: 100, to: 230, by: 1).map { $0 }
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
                Picker("Poid (kg)", selection: $viewModel.weight) {
                    ForEach(weightValues, id: \.self) { weight in
                        Text(String(format: "%0.2f kg", weight))
                    }
                }
                .background {
                    Color("OffWhite")
                }
                Picker("Taille (cm)", selection: $viewModel.size) {
                    ForEach(sizeValues, id: \.self) { size in
                        Text("\(size) cm")
                    }
                }
                Picker("Heures de repos", selection: $viewModel.hoursSleep) {
                    ForEach(sleepValue, id: \.self) { sleep in
                        Text("\(sleep)h")
                    }
                }
            }
            .listRowBackground(Color("OffWhite"))
        }
        .scrollContentBackground(.hidden)
        .background {
            Color("DimGray")
                .ignoresSafeArea()
        }
        .foregroundStyle(Color("TextColor"))
    }
}

#Preview {
    NavigationStack {
        UserDataView(viewModel: UserDataViewModel())
    }
}
