//
//  PersistenceController.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 21/05/26.
// Persistence/PersistenceController.swift
import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MusicModel")
        
        // ✅ CORRECCIÓN: El primer parámetro es la descripción, no el error
        container.loadPersistentStores { _, error in
            if let error = error {
                print("❌ Error CoreData: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Error guardando: \(error)")
            }
        }
    }
    
    func deleteSong(_ song: NSManagedObject) {
        container.viewContext.delete(song)
        save()
    }
}
