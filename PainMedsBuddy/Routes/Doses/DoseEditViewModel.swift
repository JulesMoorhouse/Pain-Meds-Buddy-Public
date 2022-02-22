//
//  DoseEditViewModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

// swiftlint:disable nesting

import AppCenterCrashes
import CoreData
import FormValidator
import Foundation

extension DoseEditView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        enum ActivePopup {
            case initialNotificationError
        }

        enum ActiveAlert {
            case deleteConfirmation,
                 elapseConfirmation,
                 currentNotificationError
        }

        private let editedDose: Dose?
        let add: Bool

        private let dataController: DataController

        private var medsController: NSFetchedResultsController<Med>
        private var meds: [Med] = []
        var dataChanged: Bool = false

        @Published var selectedMed: Med {
            didSet(oldValue) {
                if selectedMed != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var amount: String {
            didSet(oldValue) {
                if amount != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var takenDate: Date {
            didSet(oldValue) {
                if takenDate != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var details: String {
            didSet(oldValue) {
                if details != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var remindMe: Bool {
            didSet(oldValue) {
                if remindMe != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var elapsed: Bool

        @Published var hasStartupNotificationError: Bool
        @Published var showPopup = false
        @Published var activePopup: ActivePopup = .initialNotificationError
        @Published var showAlert = false
        @Published var activeAlert: ActiveAlert = .deleteConfirmation

        lazy var formValidation: FormValidation = .init(validationType: .immediate)

        lazy var validationErrors = {
            self.formValidation.$validationMessages
        }

        lazy var amountValidator: ValidationContainer = {
            var field = String(.doseEditAmount)
            let message = String(.validationZeroOrAbove,
                                 values: [field])

            return $amount.inlineValidator(
                form: formValidation,
                errorMessage: message
            ) { value in
                let isDouble = (Double(value) ?? 0.0) > 0.0
                let isInt = Int(value) != nil
                let isAboveZero = Int(value) ?? 0 > 0
                let fiveDigits = value.count <= 5
                return fiveDigits && ((isInt && isAboveZero) || isDouble)
            }
        }()

        // MARK: -

        init(dataController: DataController,
             selectedMed: Med)
        {
            add = true
            self.selectedMed = selectedMed
            self.dataController = dataController

            editedDose = nil

            amount = "\(selectedMed.medDefaultAmount)"
            takenDate = Date()
            details = DoseDefault.details
            remindMe = true
            elapsed = false

            hasStartupNotificationError = false

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
            performFetch()

            // NOTE: Double check selected med is available, shouldn't happen
            let found = meds.filter {
                $0.objectID == self.selectedMed.objectID
                    && !$0.hidden
            }
            if found.isEmpty {
                if let first = meds.first {
                    self.selectedMed = first
                }
            }
        }

        init(dataController: DataController,
             dose: Dose)
        {
            add = false
            editedDose = dose

            selectedMed = dose.med!
            amount = dose.doseAmount
            takenDate = dose.doseTakenDate
            details = dose.doseDetails
            remindMe = dose.remindMe
            elapsed = dose.doseElapsed

            hasStartupNotificationError = false

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
                Crashes.trackError(error, properties: [
                    "Position": "DoseEditViewModel.performFetch",
                    "ErrorLabel": "Failed to fetch our meds",
                ], attachments: nil)
            }
        }

        func selectionChanged() {
            amount = "\(selectedMed.medDefaultAmount)"
        }

        func setElapsed() {
            if let dose = editedDose {
                dose.objectWillChange.send()
                dose.elapsed = true

                dataController.removeReminders(for: dose)
            }
        }

        func delete() {
            // NOTE: Delete button not shown when add set
            if !add {
                // INFO: Also delete the med if this dose is the only relationship and is hidden.
                if let med = editedDose!.med {
                    if med.hidden == true {
                        let count = dataController.anyRelationships(for: [med])
                        if count == 1 {
                            dataController.delete(med)
                        }
                    }
                }
                // NOTE: removeReminders called in delete method
                dataController.delete(editedDose!)
            }
        }

        private func update(dose: Dose) {
            dose.objectWillChange.send()
            dose.amount = NSDecimalNumber(string: amount)
            dose.takenDate = takenDate
            dose.elapsed = false
            dose.details = details

            // NOTE: This is fine to set here as elapsed doses
            // are no longer editable
            dose.softElapsedDate = dose.doseSoftElapsedDate

            dose.med?.lastTakenDate = takenDate

            // NOTE: Ensure remaining is zero or above
            let remaining = Double(truncating: dose.med?.remaining ?? 0)
            let tempAmount = Double(amount) ?? Double(truncating: DoseDefault.amount)

            if (remaining - tempAmount) >= 0 {
                dose.med?.remaining =
                    dose.med?.remaining?.subtracting(NSDecimalNumber(value: tempAmount))
            }

            dose.remindMe = remindMe

            if remindMe {
                dataController.addCheckReminders(for: dose, add: true) { success in
                    if success == false {
                        self.remindMe = false
                        self.activeAlert = .currentNotificationError
                        self.showAlert = true
                    }
                }
            } else {
                dataController.removeReminders(for: dose)
            }
        }

        func checkNotificationAbility(startUp: Bool = false) {
            if remindMe {
                dataController.addCheckReminders(for: Dose(), add: false) { success in
                    if success == false {
                        self.remindMe = false
                        if startUp {
                            self.hasStartupNotificationError = true
                        } else {
                            self.activeAlert = .currentNotificationError
                            self.showAlert = true
                        }
                    } else {
                        self.hasStartupNotificationError = false
                    }
                }
            }
        }

        func save() {
            if add {
                let dose = dataController.createDose(selectedMed: selectedMed)
                update(dose: dose)
            } else {
                editedDose!.med = selectedMed
                update(dose: editedDose!)
            }

            dataController.save()
            dataController.container.viewContext.processPendingChanges()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            meds = medsController.fetchedObjects ?? []
        }
    }
}
