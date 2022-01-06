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
        @Published var doses = [Dose]()

        var medsCount: Int {
            let fetchRequest = NSFetchRequest<Med>(entityName: "Med")
            return dataController.count(for: fetchRequest)
        }

        init(dataController: DataController, showElapsedDoses: Bool) {
            self.dataController = dataController
            self.showElapsedDoses = showElapsedDoses

            let request: NSFetchRequest<Dose> = Dose.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Dose.takenDate, ascending: true)]
            request.predicate = NSPredicate(format: "elapsed = %d", showElapsedDoses)

            dosesController = NSFetchedResultsController(
                fetchRequest: request,
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
            // dataController.container.viewContext.processPendingChanges()
        }

        // INFO: Results to an array of section arrays
        func resultsToArray() -> [[Dose]] {
            let dict = Dictionary(grouping: doses) { (sequence: Dose) in
                sequence.doseFormattedMYTakenDate
            }

            // INFO: Sort by key aka doseFormattedMYTakenDate
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
