//
//  MedsViewModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import Foundation

extension MedsView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let dataController: DataController

        @Published var showingSortOrder = false
        @Published var sortOrder = Med.SortOrder.optimised
        @Published var showDeleteDenied = false

        private let medsController: NSFetchedResultsController<Med>
        @Published var meds: [Med] = []

        init(dataController: DataController) {
            self.dataController = dataController

            let medRequest: NSFetchRequest<Med> = Med.fetchRequest()
            medRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Med.lastTakenDate, ascending: true)]
            medRequest.predicate = !DataController.useHardDelete ? NSPredicate(format: "hidden = false") : nil

            medsController = NSFetchedResultsController(
                fetchRequest: medRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            medsController.delegate = self

            do {
                try medsController.performFetch()
                meds = medsController.fetchedObjects ?? []
            } catch {
                print("ERROR: Failed to fetch our meds: \(error)")
            }
        }

        func deleteMed(_ offsets: IndexSet, items: [Med]) {
            let deleteItems = offsets.map { items[$0] }

            let count = dataController.anyRelationships(for: deleteItems)
            // swiftlint:disable:next empty_count
            if count == 0 {
                for offset in offsets {
                    let item = items[offset]
                    dataController.delete(item)
                }
                dataController.save()
                dataController.container.viewContext.processPendingChanges()
            } else {
                showDeleteDenied.toggle()
            }
        }

        func hasRelationship(med: Med) -> Bool {
            dataController.hasRelationship(for: med)
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newMeds = controller.fetchedObjects as? [Med] {
                meds = newMeds
            }
        }
    }
}
