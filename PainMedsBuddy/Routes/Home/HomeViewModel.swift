//
//  HomeViewModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import Foundation

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let dosesController: NSFetchedResultsController<Dose>
        private let medsController: NSFetchedResultsController<Med>

        @Published var doses = [Dose]()
        private var meds = [Med]()

        var reaffirmedDoses: [Dose] {
            if !doses.isEmpty {
                return filterReaffirmedDoses(
                    loadedDoses: dosesController.fetchedObjects ?? [])
            }
            return []
        }

        var recentMeds: [Med] {
            getRecentMeds(
                loadedDoses: dosesController.fetchedObjects ?? [],
                loadedMeds: medsController.fetchedObjects ?? []
            )
        }

        var lowMeds: [Med] {
            if !meds.isEmpty {
                return getLowMeds(
                    loadedMeds: medsController.fetchedObjects ?? [])
            }
            return []
        }

        private let dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController

            // INFO: Construct a fetch request to show all none elapsed doses
            let doseRequest: NSFetchRequest<Dose> = Dose.fetchRequest()
            doseRequest.predicate = NSPredicate(format:
                "elapsed == false OR softElapsedDate >= %@", NSDate())

            doseRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Dose.takenDate, ascending: true),
            ]

            dosesController = NSFetchedResultsController(
                fetchRequest: doseRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // INFO: Construct a fetch request to show all none hidden meds
            let medRequest: NSFetchRequest<Med> = Med.fetchRequest()
            medRequest.predicate = !DataController.useHardDelete
                ? NSPredicate(format: "hidden = false")
                : nil
            medRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Med.lastTakenDate, ascending: true),
            ]

            medsController = NSFetchedResultsController(
                fetchRequest: medRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            super.init()

            dosesController.delegate = self
            medsController.delegate = self

            do {
                try dosesController.performFetch()
                try medsController.performFetch()
                doses = dosesController.fetchedObjects ?? []
                meds = medsController.fetchedObjects ?? []
            } catch {
                print("ERROR: Failed to fetch initial data: \(error)")
            }
        }

        // NOTE: Re-filter core data results, when items are changed
        // updated / added, as the init method which uses the
        // predicate isn't called.
        func filterReaffirmedDoses(loadedDoses: [Dose]) -> [Dose] {
            // NOTE: Produce an array of all doses which are
            // in the 3 hours soft elapsed date range, these
            // are elapsed and not hidden
            let availableSoft = loadedDoses.filter {
                if let soft = $0.softElapsedDate {
                    let notPassedSoftElapse = soft >= Date()
                    let elapsed = $0.elapsed == true

                    if let med = $0.med {
                        return elapsed && (notPassedSoftElapse && !med.hidden)
                    }
                }
                return false
            }

            // NOTE: Produce an array of all doses currently
            // being taken, even those which may have been hidden.
            let inProgress = loadedDoses.filter { $0.elapsed == false }

            // NOTE: From the availableSoft array remove any doses
            // which use the same med as inProgress, aka so the
            // user doesn't try and take a dose of an available dose
            // which is currently in progress
            let noAvailableOverdoses = availableSoft.filter { soft in
                !inProgress.contains(where: { $0.med?.objectID == soft.med?.objectID })
            }

            // NOTE: Add the two doses together
            let filtered = noAvailableOverdoses + inProgress

            return filtered.sorted(by: \Dose.doseTakenDate)
        }

        // INFO: Get a unique list of medications that don't have currently active doses.
        func getRecentMeds(loadedDoses: [Dose], loadedMeds: [Med]) -> [Med] {
            // INFO: Get unique med doses which are in progress and not hidden
            let uniqueDoseMeds = filterReaffirmedDoses(loadedDoses: loadedDoses).compactMap(\.med)

            // INFO: Get a list of meds and don't include those unique meds
            let temp = loadedMeds.filter { !uniqueDoseMeds.contains($0) }
            let sorted = temp.sortedItems(using: .lastTaken).reversed()
            let count = sorted.isEmpty ? 0 : 3
            let mapped = sorted.prefix(count).map { $0 }
            return mapped
        }

        func getLowMeds(loadedMeds: [Med]) -> [Med] {
            let temp = loadedMeds.filter { $0.medIsRunningLow == true && !$0.hidden }
                .sortedItems(using: .remaining)
            let count = temp.isEmpty ? 0 : 3
            return temp.prefix(count).map { $0 }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newDoses = controller.fetchedObjects as? [Dose] {
                doses = newDoses
            } else if let newMeds = controller.fetchedObjects as? [Med] {
                meds = newMeds
            }
        }
    }
}
