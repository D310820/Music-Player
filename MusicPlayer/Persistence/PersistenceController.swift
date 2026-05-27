//
//  PersistenceController.swift
//  MusicPlayer
//  integrantes Jose Daniel Espinoza Gomez,
//  Sofia Arely Constantino Perez ,
//  Alejandre Mayreni Vazquez Velazquez,
//  Manuela Alejandra Garay Ramires.
//  Fecha 21/05/26.
import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MusicModel")
        
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
