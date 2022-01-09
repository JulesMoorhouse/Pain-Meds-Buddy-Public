//
//  DoseMedSelectViewModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import Foundation

extension DoseMedSelectView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let dataController: DataController

        @Published var showingSortOrder = false
        @Published var sortOrder = Med.SortOrder.optimised

        private let medsController: NSFetchedResultsController<Med>
        @Published var meds: [Med] = []

        init(dataController: DataController) {
            self.dataController = dataController

            let request: NSFetchRequest<Med> = Med.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Med.lastTakenDate, ascending: true)]
            request.predicate = !DataController.useHardDelete ? NSPredicate(format: "hidden = false") : nil

            self.medsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            medsController.delegate = self

            do {
                try medsController.performFetch()
                self.meds = medsController.fetchedObjects ?? []
            } catch {
                print("ERROR: Failed to fetch our meds: \(error)")
            }
        }
    }
}
