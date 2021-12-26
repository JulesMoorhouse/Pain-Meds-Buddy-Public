//
//  DataController.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import SwiftUI

/// An environment singleton responsible for managing out Core Data stack, including handling saving,
/// counting fetch requests, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to store all our data.
    private let _container: NSPersistentCloudKitContainer
    private let semaphore = DispatchSemaphore(value: 0)

    var container: NSPersistentContainer {
        semaphore.wait()
        semaphore.signal()
        return _container
    }

    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing).
    /// or on permanent storage (for use in regular app runs).
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store data in temporary memory or not.
    init(inMemory: Bool = false) {
        _container = NSPersistentCloudKitContainer(name: "Main")
        let semaphore = self.semaphore

        // INFO: For testing and previewing purposes, we create a temporary,
        // in-memory database by writing to /dev/null so our data is
        // destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        _container.loadPersistentStores { _, error in
            semaphore.signal()
            if let error = error as NSError? {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
        _container.viewContext.automaticallyMergesChangesFromParent = true
        _container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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

    // INFO: Returns true if any Dose has a specific med
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

    // INFO: Returns true if any Dose has any of the meds specified
    func anyRelationships(for meds: [Med]) -> Int {
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

    func createMed() -> Med {
        let med: Med

        if let first = getFirstMed() {
            med = first
        } else {
            let newMed = Med(context: container.viewContext)
            MedDefault.setSensibleDefaults(newMed)
            med = newMed
        }

        return med
    }

    func createMedForDose(dose: Dose) -> Med {
        let med: Med = createMed()
        dose.med = med
        save()
        return med
    }

    func createDose(selectedMed: Med?) -> Dose {
        let dose = Dose(context: container.viewContext)
        DoseDefault.setSensibleDefaults(dose)
        if let selectedMed = selectedMed {
            dose.med = selectedMed
        } else {
            dose.med = createMed()
        }
        save()
        return dose
    }

    /// Creates example meds and doses to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for medCounter in 1 ... 20 {
            // INFO: One to one relationship
            let med = Med(context: viewContext)
            med.title = "Med example \(medCounter)"
            med.notes = "This is an exmaple med \(medCounter)"
            med.defaultAmount = NSDecimalNumber(value: Int16.random(in: 1 ... 10))
            med.dosage = NSDecimalNumber(value: Int16.random(in: 100 ... 600))
            med.color = Med.colors.randomElement()
            med.measure = "mg"
            med.form = "Pills"
            med.remaining = Int16.random(in: 0 ... 99)
            med.duration = Int16("04:00:00".timeToSeconds)
            med.durationGap = Int16("00:20:00".timeToSeconds)
            med.creationDate = Date()
            med.lastTakenDate = Date()
            med.symbol = Symbol.allSymbols.randomElement()?.id
            med.sequence = Int16.random(in: 1 ... 3)

            let dose = Dose(context: viewContext)
            dose.takenDate = (medCounter % 2 == 0) ? Date() : Date.yesterday
            dose.elapsed = Bool.random()
            dose.amount = NSDecimalNumber(value: Int16.random(in: 1 ... 10))

            med.dose = dose
        }

        try viewContext.save()
    }

    /// Saves our Core Data context if there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our
    /// attributes are optional.
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
