//
//  UserRepository.swift
//  Arista
//
//  Created by Thibault Giraudon on 29/04/2025.
//

import Foundation
import CoreData

struct UserRepository {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }
    
    func getUser() throws -> User? {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        return try viewContext.fetch(request).first
    }
    
    func saveUser(name: String, email: String, weight: Double, size: Int, hoursSleep: Int) throws {
        let user = try getUser() ?? User(context: viewContext)
        
        user.name = name
        user.email = email
        user.weight = weight
        user.size = Int64(size)
        user.hoursSleep = Int64(hoursSleep)
        
        try viewContext.save()
    }
}
