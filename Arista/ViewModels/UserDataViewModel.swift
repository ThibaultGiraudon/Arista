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
    @Published var weight: Double = 75.0
    @Published var size: Int = 175
    @Published var hoursSleep: Int = 8
    
    /// Computes if save button should be disable
    var shouldDisable: Bool {
        name.isEmpty || email.isEmpty || weight < 30 || weight > 230 || size < 100 || size > 250
    }
    
    /// Shared struct catching error thrown
    let appState = AppState.shared
    
    /// Gives the initials of the registered user
    var initials: String {
        let names = self.name.split(separator: " ")
        var initials = ""
        for sub in names {
            initials += sub.capitalized.prefix(1)
        }
        return initials
    }

    private var viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        fetchUserData()
    }

    /// Fetches user from the repository and updates local states.
    private func fetchUserData() {
        do {
            guard let user = try UserRepository().getUser() else {
                throw URLError(.badURL)
            }
            self.email = user.email ?? ""
            self.name = user.name ?? ""
            self.weight = user.weight
            self.size = Int(user.size)
            self.hoursSleep = Int(user.hoursSleep)
        } catch {
            appState.reportError("Error fetching user: \(error.localizedDescription)")
        }
    }
    
    /// Saves new user's datas in the repository.
    func saveUser() {
        do {
            try UserRepository().saveUser(name: name, email: email, weight: weight, size: size, hoursSleep: hoursSleep)
        } catch {
            appState.reportError("Error updating user: \(error.localizedDescription)")
        }
    }
}
