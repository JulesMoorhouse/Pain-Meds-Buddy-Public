//
//  DataController.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    static var preview: DataController = {
        let dataController  = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error crearting preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    func createSampleData() throws {
        let viewContext = container.viewContext

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        for i in 1...20 {
            let dose = Dose(context: viewContext)
            dose.takenDate = formatter.date(from: (i % 2 == 0) ? "2021/12/02 11:00" : "2021/12/01 11:00")
            dose.taken = Bool.random()
            dose.amount = NSDecimalNumber(value: Int16.random(in: 1...10))
            
            // INFO: One to one relationship
            let med = Med(context: viewContext)
            med.title = "Med example \(i)"
            med.notes = "This is an exmaple med \(i)"
            med.defaultAmount = 1
            med.dosage = NSDecimalNumber(value: Int16.random(in: 100...600))
            med.color = Med.colors.randomElement()
            med.measure = "mg"
            med.form = "Pills"
            med.remaining = 99
            med.duration = 240
            med.durationGap = 0
            med.creationDate = Date()
            med.dose = dose
            med.symbol = Symbol.allSymbols.randomElement()?.id
            med.sequence = Int16.random(in: 1...3)
        }
        
        try viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Med.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Dose.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
}
