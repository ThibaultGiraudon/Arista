//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import CoreData

class AppState: ObservableObject {
    @Published var showError = false
    @Published var alertTitle = ""
    
    static let shared = AppState()
    
    func reportError(_ title: String) {
        self.alertTitle = title
        self.showError = true
    }
}

struct PersistenceController {
    static let shared = PersistenceController()
    

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        do {
            try viewContext.save()
        } catch {
            AppState.shared.reportError("Failed to create CoreData object")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Arista")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                AppState.shared.reportError("CoreData Error: \(error.localizedDescription)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try DefaultData(viewContext: container.viewContext).apply()
        } catch {
            AppState.shared.reportError("Failed to create default data")
        }
    }
}
