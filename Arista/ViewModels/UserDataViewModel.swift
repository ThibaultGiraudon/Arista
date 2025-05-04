//
//  UserDataViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation
import CoreData

class UserDataViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchUserData()
    }

    private func fetchUserData() {
        do {
            guard let user = try UserRepository().getUser() else {
                throw URLError(.badURL)
            }
            self.email = user.email ?? ""
            self.name = user.name ?? ""
        } catch {
            print(error.localizedDescription)
        }
    }
}
