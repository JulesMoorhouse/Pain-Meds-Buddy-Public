//
//  DataController.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AppCenterCrashes
import CoreData
import SwiftUI

/// An environment singleton responsible for managing out Core Data stack, including handling saving,
/// counting fetch requests, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to store all our data.
    private let _container: NSPersistentCloudKitContainer
    private let semaphore = DispatchSemaphore(value: 0)

    var container: NSPersistentContainer {
        if !DataController.isUnitTesting {
            semaphore.wait()
            semaphore.signal()
        }

        return _container
    }

    /// Initialises a data controller, either in memory (for temporary use such as testing and previewing).
    /// or on permanent storage (for use in regular app runs).
    ///
    /// Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store data in temporary memory or not.
    init(inMemory: Bool = false) {
        _container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        let semaphore = self.semaphore

        // INFO: For testing and previewing purposes, we create a temporary,
        // in-memory database by writing to /dev/null so our data is
        // destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        _container.loadPersistentStores { _, error in
            if !DataController.isUnitTesting {
                semaphore.signal()
            }
            if let error = error as NSError? {
                Crashes.trackError(error, properties: [
                    "Position": "DataController.init",
                    "ErrorLabel": "Fatal error loading store",
                ], attachments: nil)
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            if DataController.shouldWipeData {
                self.deleteAll()
            }

            if DataController.isUITesting || DataController.isSnapshotUITesting {
                self.deleteAll()
                self.handleSampleDataOptions(
                    appStore: DataController.isSnapshotUITesting)
            }
        }
        _container.viewContext.automaticallyMergesChangesFromParent = true
        _container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        if !DataController.isUITesting && !DataController.isUnitTesting {
            _container.viewContext.undoManager = nil
            _container.viewContext.shouldDeleteInaccessibleFaults = true

            do {
                try _container.viewContext.setQueryGenerationFrom(.current)
            } catch {
                fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
            }
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData(appStore: false)
        } catch {
            Crashes.trackError(error, properties: [
                "Position": "DataController.preview",
                "ErrorLabel": "Fatal error creating preview",
            ], attachments: nil)
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    /// Cache model so the model does not get called more than once
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            Crashes.trackError(NSError(), properties: [
                "Position": "DataController.model",
                "ErrorLabel": "Failed to locate model file.",
            ], attachments: nil)
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            Crashes.trackError(NSError(), properties: [
                "Position": "DataController.model",
                "ErrorLabel": "Failed to load model file.",
            ], attachments: nil)
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    /**
     Handle remote store change notifications (.NSPersistentStoreRemoteChange).
     */
//    @objc func storeRemoteChange(_ notification: Notification) {
//        print("### \(#function): Merging changes from the other persistent store coordinator.")
//    }

    /// Saves our Core Data context if there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our
    /// attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error as NSError {
                print("ERROR: Could not save. \(error), \(error.userInfo)")
                Crashes.trackError(error, properties: [
                    "Position": "DataController.save",
                    "ErrorLabel": "Could not save",
                ], attachments: nil)
            }
        }
    }

    func delete(_ object: NSManagedObject) {
        if let dose = object as? Dose {
            removeReminders(for: dose)
        }
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Med.fetchRequest()
        delete(fetchRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Dose.fetchRequest()
        delete(fetchRequest2)
    }

    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest1.resultType = .resultTypeObjectIDs

        if let delete = try? container.viewContext.execute(batchDeleteRequest1) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }

    func deleteIterateAll() throws {
        let doseRequest = NSFetchRequest<Dose>(entityName: "Dose")
        let tempDoses = try container.viewContext.fetch(doseRequest)
        for dose in tempDoses {
            delete(dose)
        }
        save()

        let medRequest = NSFetchRequest<Med>(entityName: "Med")
        let tempMeds = try container.viewContext.fetch(medRequest)
        for med in tempMeds {
            delete(med)
        }
        save()
    }

    func deleteAllDoseHistory() throws {
        let doseRequest = NSFetchRequest<Dose>(entityName: "Dose")

        doseRequest.predicate = NSPredicate(format:
            "elapsed == true")

        let tempDoses = try container.viewContext.fetch(doseRequest)
        for dose in tempDoses {
            delete(dose)
        }
        save()
    }
}
