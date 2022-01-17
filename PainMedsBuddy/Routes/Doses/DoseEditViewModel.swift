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
        private let dose: Dose
        let add: Bool

        private let dataController: DataController

        private let medsController: NSFetchedResultsController<Med>
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

        init(dataController: DataController, dose: Dose, add: Bool) {
            self.dose = dose
            self.add = add
            self.dataController = dataController

            let request: NSFetchRequest<Med> = Med.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Med.lastTakenDate, ascending: true)]
            request.predicate = !DataController.useHardDelete ? NSPredicate(format: "hidden = false") : nil

            medsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            if let currentMed = dose.med {
                selectedMed = currentMed
                if add {
                    amount = currentMed.medDefaultAmount
                }
            } else {
                selectedMed = Med(context: dataController.container.viewContext)
            }

            amount = dose.doseAmount
            takenDate = dose.doseTakenDate

            super.init()

            medsController.delegate = self

            do {
                try medsController.performFetch()
                meds = medsController.fetchedObjects ?? []
            } catch {
                print("ERROR: Failed to fetch our meds: \(error)")
            }
        }

        func selectionChanged() {
            let med = selectedMed

            dose.amount = med.defaultAmount

            amount = "\(med.medDefaultAmount)"

            if dose.med != med {
                dose.med = med
            }

            update()
        }

        private func update() {
            dose.objectWillChange.send()

            dose.amount = NSDecimalNumber(string: amount)

            dose.takenDate = takenDate
        }

        func delete() {
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

        func save() {
            if dose.med != selectedMed {
                dose.med = selectedMed
            }
            dose.med?.lastTakenDate = takenDate
            dose.med?.remaining -= Int16(amount) ?? 0
            dataController.save()
            dataController.container.viewContext.processPendingChanges()
        }
    }
}
