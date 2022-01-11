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
        @Published var meds = [Med]()

        private let dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all none elapsed doses
            let doseRequest: NSFetchRequest<Dose> = Dose.fetchRequest()
            doseRequest.predicate = NSPredicate(format: "elapsed == false AND med != nil")
            doseRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Dose.takenDate, ascending: true)]

            dosesController = NSFetchedResultsController(
                fetchRequest: doseRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // Construct a fetch request to show all none hidden meds
            let medRequest: NSFetchRequest<Med> = Med.fetchRequest()
            medRequest.predicate = !DataController.useHardDelete ? NSPredicate(format: "hidden = false") : nil
            medRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Med.lastTakenDate, ascending: true)]

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
        
        func canTakeMeds() -> [Med] {
            let uniqueDoseMeds = Array(Set(doses.filter { $0.med != nil }.compactMap(\.med)))

            // INFO" Get unique meds which are currently not elapsed
            var temp = meds.filter { !uniqueDoseMeds.contains($0) }
            temp = temp.sortedItems(using: .lastTaken)
            let count = temp.count == 0 ? 0 : 3
            return temp.prefix(count).map { $0 }
        }

        func lowMeds() -> [Med] {
            let temp = meds.sortedItems(using: .remaining)
            let count = temp.count == 0 ? 0 : 3
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
