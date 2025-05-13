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
    
    let appState = AppState.shared
    
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
}
