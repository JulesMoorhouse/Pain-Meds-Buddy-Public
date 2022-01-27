//
//  DosesViewModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import Foundation

extension DosesView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let dataController: DataController

        let showElapsedDoses: Bool

        private let dosesController: NSFetchedResultsController<Dose>
        @Published private var doses = [Dose]()

        var medsCount: Int {
            let medRequest = NSFetchRequest<Med>(entityName: "Med")
            return dataController.count(for: medRequest)
        }

        init(dataController: DataController, showElapsedDoses: Bool) {
            self.dataController = dataController
            self.showElapsedDoses = showElapsedDoses

            let doseRequest: NSFetchRequest<Dose> = Dose.fetchRequest()
            doseRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Dose.takenDate, ascending: false)
            ]
            doseRequest.predicate = NSPredicate(format: "elapsed = %d", showElapsedDoses)

            dosesController = NSFetchedResultsController(
                fetchRequest: doseRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            dosesController.delegate = self

            do {
                try dosesController.performFetch()
                doses = dosesController.fetchedObjects ?? []
            } catch {
                print("ERROR: Failed to fetch our doses: \(error)")
            }
        }

        func deleteDose(_ offsets: IndexSet, from doses: [Dose]) {
            for offset in offsets {
                let item = doses[offset]
                dataController.delete(item)
            }
            dataController.save()
        }

        // INFO: Results to an array of section arrays
        func resultsToArray() -> [[Dose]] {
            let dict = Dictionary(grouping: doses) { (sequence: Dose) in
                sequence.doseFormattedTakenDateLong
            }

            // INFO: Sort by key aka doseFormattedTakenDateLong
            let sorted = dict.sorted(by: { $0.key > $1.key })

            return sorted.map(\.value)
        }

        func createMed() -> Med {
            dataController.createMed()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newDoses = controller.fetchedObjects as? [Dose] {
                doses = newDoses
            }
        }
    }
}
