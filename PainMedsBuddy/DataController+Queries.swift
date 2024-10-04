//
//  DataController+Queries.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import SwiftUI

extension DataController {
    // INFO: Returns true if any Dose has a specific med
    func hasRelationship(for med: Med) -> Bool {
        let doseRequest = NSFetchRequest<Dose>(entityName: "Dose")
        doseRequest.predicate = NSPredicate(format: "med == %@", med)
        do {
            let tempDoses = try container.viewContext.fetch(doseRequest)
            if tempDoses.first != nil {
                return true
            }
        } catch {
            print("ERROR: Checking data for dose \(error.localizedDescription)")
        }

        return false
    }

    // INFO: Returns a count if any Dose has any of the meds specified
    func anyRelationships(for meds: [Med]) -> Int {
        let doseRequest = NSFetchRequest<Dose>(entityName: "Dose")
        doseRequest.predicate = NSPredicate(format: "med = %@", argumentArray: meds)
        do {
            let tempDoses = try container.viewContext.fetch(doseRequest)
            return tempDoses.count
        } catch {
            print("ERROR: Checking data for doses \(error.localizedDescription)")
        }

        return 0
    }

    func getMedDoses(for med: Med, elapsed: Bool) -> [Dose] {
        let doseRequest = NSFetchRequest<Dose>(entityName: "Dose")
        doseRequest.predicate = NSPredicate(format: "med == %@", med)
        do {
            let tempDoses = try container.viewContext.fetch(doseRequest)
            return tempDoses
        } catch {
            print("ERROR: Checking data for dose \(error.localizedDescription)")
        }

        return []
    }

    func createMed() -> Med {
        let med: Med

        if let first = getFirstMed() {
            med = first
        } else {
            let newMed = Med(context: container.viewContext)
            newMed.setSensible()
            med = newMed
        }

        return med
    }

    func createDose(selectedMed: Med?) -> Dose {
        let dose = Dose(context: container.viewContext)
        dose.setSensible()
        if let thisMed = selectedMed {
            dose.med = thisMed
        } else {
            dose.med = createMed()
        }
        save()

        return dose
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

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    static func resultsToArray<T>(_ result: FetchedResults<T>) -> [T] {
        var temp: [T] = []
        temp = result.map { $0 }

        return temp
    }

    func getFirstMed() -> Med? {
        let medRequest = NSFetchRequest<Med>(entityName: "Med")
        medRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Med.lastTakenDate, ascending: false),
        ]
        do {
            let tempMeds = try container.viewContext.fetch(medRequest)
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
}
