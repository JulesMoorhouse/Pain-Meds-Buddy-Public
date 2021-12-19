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
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error crearting preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    func hasRelationship(for med: Med) -> Bool {
        let fetchRequest = NSFetchRequest<Dose>(entityName: "Dose")
        fetchRequest.predicate = NSPredicate(format: "med == %@", med)
        do {
            let tempDoses = try container.viewContext.fetch(fetchRequest)
            if tempDoses.first != nil {
                return true
            }
        } catch {
            print("Error checking data for dose \(error.localizedDescription)")
        }
        
        return false
    }

    func AnyRelationships(for meds: [Med]) -> Int {
        let fetchRequest = NSFetchRequest<Dose>(entityName: "Dose")
        fetchRequest.predicate = NSPredicate(format: "med IN %@", meds)
        do {
            let tempDoses = try container.viewContext.fetch(fetchRequest)
            return tempDoses.count
        } catch {
            print("Error checking data for doses \(error.localizedDescription)")
        }
        
        return 0
    }
    
    func createMed(firstMed: Med?) -> Med {
        let med: Med
    
        if let first = firstMed {
            med = first
        } else {
            let newMed = Med(context: container.viewContext)
            MedDefault.setSensibleDefaults(newMed)
            med = newMed
        }
    
        return med
    }
    
    func createMedForDose(dose: Dose, firstMed: Med?) -> Med {
        let med: Med = createMed(firstMed: firstMed)
        dose.med = med
        save()
        return med
    }
    
    func createDose(firstMed: Med?) -> Dose {
        let dose = Dose(context: container.viewContext)
        DoseDefault.setSensibleDefaults(dose)
        dose.med = createMed(firstMed: firstMed)
        save()
        return dose
    }
    
    func createSampleData() throws {
        let viewContext = container.viewContext

        for i in 1...20 {
            // let linkedDose = Bool.random()
            
            // INFO: One to one relationship
            let med = Med(context: viewContext)
            // med.title = "Med example \(i) \(linkedDose ? "linked" : "")"
            med.title = "Med example \(i)"
            med.notes = "This is an exmaple med \(i)"
            med.defaultAmount = NSDecimalNumber(value: Int16.random(in: 1...10))
            med.dosage = NSDecimalNumber(value: Int16.random(in: 100...600))
            med.color = Med.colors.randomElement()
            med.measure = "mg"
            med.form = "Pills"
            med.remaining = Int16.random(in: 0...99)
            med.duration = Int16("04:00:00".timeToSeconds)
            med.durationGap = Int16("00:20:00".timeToSeconds)
            med.creationDate = Date()
            med.lastTakenDate = Date()
            // if linkedDose {
            let dose = Dose(context: viewContext)
            dose.takenDate = (i % 2 == 0) ? Date() : Date.yesterday
            dose.elapsed = Bool.random()
            dose.amount = NSDecimalNumber(value: Int16.random(in: 1...10))
                
            med.dose = dose
            // }
            med.symbol = Symbol.allSymbols.randomElement()?.id
            med.sequence = Int16.random(in: 1...3)
        }
        
        try viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
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
    
    static func resultsToArray<T>(_ result: FetchedResults<T>) -> [T] {
        var temp: [T] = []
        temp = result.map { $0 }
        
        return temp
    }
    
    func getFirstMed() -> Med? {
        let fetchRequest = NSFetchRequest<Med>(entityName: "Med")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Med.sequence, ascending: false)
        ]
        do {
            let tempMeds = try container.viewContext.fetch(fetchRequest)
            if tempMeds.count > 0 {
                if let first = tempMeds.first {
                    return first
                }
            }
        } catch {
            fatalError("Error loading data")
        }
        
        return nil
    }
}
