//
//  DataController.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import SwiftUI
import UserNotifications

// swiftlint:disable type_body_length
// swiftlint:disable file_length

/// An environment singleton responsible for managing out Core Data stack, including handling saving,
/// counting fetch requests, and dealing with sample data.
class DataController: ObservableObject {
    /// The lone CloudKit container used to store all our data.
    private let _container: NSPersistentCloudKitContainer
    private let semaphore = DispatchSemaphore(value: 0)

    public static let useHardDelete = true
    public static let useAddScreenDefaults = false

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
    }

    static var isUnitTesting: Bool {
        #if DEBUG
            if ProcessInfo.processInfo.environment["UNITTEST"] == "1" {
                return true
            }
        #endif
        return false
    }

    static var isUITesting: Bool {
        #if DEBUG
            if CommandLine.arguments.contains("enable-ui-testing") {
                return true
            }
        #endif
        return false
    }

    static var isSnapshotUITesting: Bool {
        #if DEBUG
            if CommandLine.arguments.contains("enable-snapshot-ui-testing") {
                return true
            }
        #endif
        return false
    }

    static var shouldWipeData: Bool {
        #if DEBUG
            if CommandLine.arguments.contains("wipe-data") {
                return true
            }
        #endif
        return false
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData(appStore: false)
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    /// Cache model so the model does not get called more than once
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
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
            print("ERROR: Checking data for dose \(error.localizedDescription)")
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
            print("ERROR: Checking data for doses \(error.localizedDescription)")
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
    func createSampleData(appStore: Bool, medsRequested: Int, medDosesRequired: Int) throws {
        let viewContext = container.viewContext

        struct Drug {
            var name = ""
            var mGrams = 0
            var defAmt: Int16 = 0
            var duration: Int16 = 0
            var lastTakeDate = Date()
            var hasDose: Bool
        }

        let drugs: [Drug] = [
            Drug(name: "Paracetamol", mGrams: 500, defAmt: 2, duration: (4 * 60) * 60, hasDose: true),
            Drug(name: "Ibuprofen", mGrams: 200, defAmt: 2, duration: (4 * 60) * 60, hasDose: true),
            Drug(name: "Codeine", mGrams: 30, defAmt: 2, duration: (4 * 60) * 60, hasDose: false),
        ]

        let maxMeds = appStore ? min(drugs.count, medsRequested) : medsRequested

        for medIndex in 0 ..< maxMeds {
            let drug = appStore ? drugs[medIndex] : drugs.randomElement()!

            // INFO: One to one relationship
            let med = Med(context: viewContext)
            med.title = drug.name
            med.notes = "Notes about taking \(drug.name) x \(drug.mGrams) Pills"
            med.defaultAmount = NSDecimalNumber(value: drug.defAmt)
            med.dosage = NSDecimalNumber(value: drug.mGrams)
            med.color = Med.colours.randomElement()
            med.measure = "mg"
            med.form = "Pills"
            med.remaining = Int16.random(in: 0 ... 99)
            med.durationSeconds = drug.duration
            med.durationGapSeconds = Int16("00:20:00".timeToSeconds)
            med.creationDate = Date().adding(days: -20)
            med.lastTakenDate = Date().adding(days: -20)
            med.symbol = Symbol.allSymbols.randomElement()?.id
            med.hidden = false

            if drug.hasDose {
                if medDosesRequired > 0 {
                    var takenDates = createSampleTakenDate(amount: medDosesRequired)
                    for _ in 1 ... medDosesRequired {
                        let dose = Dose(context: viewContext)
                        dose.med = med

                        let tempAmount = Int16.random(in: 1 ... drug.defAmt)

                        let tempTaken: Date = takenDates.first!
                        dose.takenDate = tempTaken
                        if tempTaken > med.lastTakenDate! {
                            med.lastTakenDate = tempTaken
                        }

                        dose.elapsed = dose.doseElapsedDate == nil
                            ? true
                            : dose.doseElapsedDate! < Date()

                        dose.amount = NSDecimalNumber(value: tempAmount)
                        dose.details = "Notes about - \(drug.name) \(tempAmount) x \(drug.mGrams)mg Pills"
                        dose.remindMe = true

                        takenDates.remove(at: 0)
                    }
                }
            }
        }

        try viewContext.save()
    }

    func createSampleTakenDate(amount: Int) -> [Date] {
        let tenDaysAgo = Date() - 10

        var takenDates = [Date]()
        takenDates.append(Date().adding(minutes: -Int.random(in: 10 ... 55)))
        takenDates.append(Date().adding(minutes: -Int.random(in: 60 ... 360)))
        takenDates.append(tenDaysAgo)

        if amount > 0 {
            for _ in 0 ... amount {
                takenDates.append(Date.random(in: tenDaysAgo ..< Date().adding(hours: -4)))
            }
        }
        return takenDates
    }

    func createSampleData(appStore: Bool) throws {
        try? createSampleData(
            appStore: appStore,
            medsRequested: 5,
            medDosesRequired: 4)
    }

    private func handleSampleDataOptions(appStore: Bool) {
        do {
            if let parameter = CommandLine
                .arguments
                .joined(separator: " ")
                .extractedParameter
            {
                let strings: [String] = parameter.components(separatedBy: ",")
                let numbers: [Int] = strings.map { Int($0)! }
                let (meds, doses) = (numbers[0], numbers[1])
                if meds == 0, doses > 0 {
                    fatalError("ERROR: You can not create sample data with doses and no meds!")
                } else if meds == 0, doses == 0 {
                    fatalError("ERROR: You can not create sample data with no doses and no meds!")
                }
                try createSampleData(
                    appStore: appStore,
                    medsRequested: meds,
                    medDosesRequired: doses)
            } else {
                try createSampleData(appStore: appStore)
            }
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
    }

    /// Process any doses which should now be elapsed
    func processDoses() {
        let doseRequest = NSFetchRequest<Dose>(entityName: "Dose")
        doseRequest.predicate = NSPredicate(format: "elapsed == false AND med != nil")
        do {
            let tempDoses = try container.viewContext.fetch(doseRequest)
            for dose in tempDoses where dose.doseShouldHaveElapsed {
                dose.elapsed = true
            }
            save()
        } catch {
            print("ERROR: Checking data for doses \(error.localizedDescription)")
        }
    }

    /// Saves our Core Data context if there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our
    /// attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error as NSError {
                print("ERROR: Could not save. \(error), \(error.userInfo)")
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
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Dose.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }

    func deleteIterateAll() throws {
        let doseRequest = NSFetchRequest<Dose>(entityName: "Dose")
        do {
            let tempDoses = try container.viewContext.fetch(doseRequest)
            for dose in tempDoses {
                delete(dose)
            }
            save()
        } catch {
            print("ERROR: Deleting doses \(error.localizedDescription)")
        }

        let medRequest = NSFetchRequest<Med>(entityName: "Med")
        do {
            let tempMeds = try container.viewContext.fetch(medRequest)
            for med in tempMeds {
                delete(med)
            }
            save()
        } catch {
            print("ERROR: Deleting meds \(error.localizedDescription)")
        }
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
            NSSortDescriptor(keyPath: \Med.lastTakenDate, ascending: false),
        ]
        do {
            let tempMeds = try container.viewContext.fetch(fetchRequest)
            if !tempMeds.isEmpty {
                if let first = tempMeds.first {
                    return first
                }
            }
        } catch {
            fatalError("Error loading data")
        }

        return nil
    }

    func addCheckReminders(
        for dose: Dose,
        add: Bool,
        completion: @escaping (Bool) -> Void)
    {
        let centre = UNUserNotificationCenter.current()

        centre.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotifications { success in
                    if success {
                        if add {
                            self.placeReminders(
                                for: dose,
                                completion: completion)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
            case .authorized:
                if add {
                    self.placeReminders(
                        for: dose,
                        completion: completion)
                }
            default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    func removeReminders(for dose: Dose) {
        let centre = UNUserNotificationCenter.current()
        let id = dose.objectID.uriRepresentation().absoluteString

        centre.removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func requestNotifications(completion: @escaping (Bool) -> Void) {
        let centre = UNUserNotificationCenter.current()

        centre.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }

    private func placeReminders(for dose: Dose, completion: @escaping (Bool) -> Void) {
        if let notificationDate = dose.doseElapsedDate {
            let content = UNMutableNotificationContent()
            content.title = dose.doseSearchableDisplay
            content.subtitle = String(.notificationSubtitle)

            content.sound = .default

            let components = Calendar.current
                .dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: notificationDate)

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: true)

            let id = dose.objectID.uriRepresentation().absoluteString
            let request = UNNotificationRequest(
                identifier: id,
                content: content,
                trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                DispatchQueue.main.async {
                    if error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
}
