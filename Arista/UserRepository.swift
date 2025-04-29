//
//  UserRepository.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

struct UserRepository {
    let viewContent: NSManagedObjectContext
    
    init(viewContent: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContent = viewContent
    }
    
    func getUser() throws -> User? {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        return try viewContent.fetch(request).first
    }
}
