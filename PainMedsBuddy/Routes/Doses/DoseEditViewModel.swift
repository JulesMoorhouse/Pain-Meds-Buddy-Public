//
//  DoseEditViewModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import FormValidator
import Foundation

extension DoseEditView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private var dose: Dose
        let add: Bool

        private let dataController: DataController

        private var medsController: NSFetchedResultsController<Med>
        private var meds: [Med] = []

        @Published var selectedMed: Med
        @Published var amount: String
        @Published var takenDate: Date

        lazy var formValidation: FormValidation = {
            FormValidation(validationType: .immediate)
        }()

        lazy var validationErrors = {
            self.formValidation.$validationMessages
        }

        lazy var amountValidator: ValidationContainer = {
            var field = String(.doseEditAmount)
            let message = String(.validationOneOrAbove,
                                 values: [field])

            return $amount.inlineValidator(
                form: formValidation,
                errorMessage: message
            ) { value in
                value.isNumber && (Int(value) ?? 0) > 0
            }
        }()

        init(dataController: DataController,
             selectedMed: Med)
        {
            add = true
            self.selectedMed = selectedMed
            self.dataController = dataController
            dose = Dose()

            amount = "\(selectedMed.medDefaultAmount)"
            takenDate = DoseDefault.takenDate

            let request: NSFetchRequest<Med> = Med.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Med.lastTakenDate, ascending: true)]
            request.predicate = !DataController.useHardDelete ? NSPredicate(format: "hidden = false") : nil

            medsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            performFetch()
        }

        init(dataController: DataController,
             dose: Dose)
        {
            self.dose = dose
            add = false
            self.dataController = dataController
            selectedMed = dose.med!

            let request: NSFetchRequest<Med> = Med.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Med.lastTakenDate, ascending: true)]
            request.predicate = !DataController.useHardDelete ? NSPredicate(format: "hidden = false") : nil

            medsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            amount = dose.doseAmount
            takenDate = dose.doseTakenDate

            super.init()
            performFetch()
        }

        func performFetch() {
            medsController.delegate = self

            do {
                try medsController.performFetch()
                meds = medsController.fetchedObjects ?? []
            } catch {
                print("ERROR: Failed to fetch our meds: \(error)")
            }
        }

        func selectionChanged() {
            if !add {
                dose.amount = selectedMed.defaultAmount

                amount = "\(selectedMed.medDefaultAmount)"

                if dose.med != selectedMed {
                    dose.med = selectedMed
                }
            } else {
                amount = "\(selectedMed.medDefaultAmount)"
            }
        }

        func delete() {
            if !add {
                // INFO: Also delete the med if this dose is the only relationship and is hidden.
                if let med = dose.med {
                    if med.hidden == true {
                        let count = dataController.anyRelationships(for: [med])
                        if count == 1 {
                            dataController.delete(med)
                        }
                    }
                }
                dataController.delete(dose)
                // presentationMode.wrappedValue.dismiss()
            }
        }

        func save() {
            dose.objectWillChange.send()

            if add {
                dose = dataController.createDose(selectedMed: selectedMed)
            } else {
                dose.med = selectedMed
            }

            dose.amount = NSDecimalNumber(string: amount)
            dose.takenDate = takenDate
            dose.elapsed = false

            dose.med?.lastTakenDate = takenDate
            dose.med?.remaining -= Int16(amount) ?? 0

            dataController.save()
            dataController.container.viewContext.processPendingChanges()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newMeds = controller.fetchedObjects as? [Med] {
                meds = newMeds
            }
        }
    }
}
