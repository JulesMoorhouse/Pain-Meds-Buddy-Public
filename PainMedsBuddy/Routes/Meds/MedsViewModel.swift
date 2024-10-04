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
            for offset in offsets {
                let med = items[offset]
                let count = dataController.anyRelationships(for: [med])
                // swiftlint:disable:next empty_count
                if count == 0 && DataController.useHardDelete {
                    dataController.delete(med)
                } else {
                    med.hidden = true
                }
            }
            dataController.save()
            dataController.container.viewContext.processPendingChanges()
        }

        func hasRelationship(med: Med) -> Bool {
            dataController.hasRelationship(for: med)
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            print("### MedsViewModel - controllerDidChangeContent")
            meds = medsController.fetchedObjects ?? []
        }
    }
}
