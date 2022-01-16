//
//  MedEditViewModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import FormValidator
import Foundation

extension MedEditView {
    class ViewModel: NSObject, ObservableObject {
        private let med: Med?
        let add: Bool
        let hasRelationship: Bool

        private let dataController: DataController

        @Published var title: String
        @Published var defaultAmount: String
        @Published var colour: String
        @Published var symbol: String
        @Published var dosage: String
        @Published var durationDate: String
        @Published var durationGapDate: String
        @Published var measure: String
        @Published var form: String
        @Published var notes: String
        @Published var remaining: String

        lazy var formValidation: FormValidation = {
            FormValidation(validationType: .immediate)
        }()

        lazy var validationErrors = {
            self.formValidation.$validationMessages
        }

        lazy var titleValidation: ValidationContainer = {
            $title.inlineValidator(
                form: formValidation,
                errorMessage: "Title must have at least 2 letters") { value in
                    !value.isEmpty && value.count > 2
            }
        }()

        lazy var defaultAmountValidator: ValidationContainer = {
            $defaultAmount.inlineValidator(
                form: formValidation,
                errorMessage: "Default amount must 1 or above") { value in
                    !value.isEmpty && !value.isNumber
            }
        }()

        lazy var dosageValidator: ValidationContainer = {
            $dosage.inlineValidator(
                form: formValidation,
                errorMessage: "Dosage must be 1 or above") { value in
                    !value.isEmpty && !value.isNumber
            }
        }()

        lazy var durationDateValidator: ValidationContainer = {
            $durationDate.inlineValidator(
                form: formValidation,
                errorMessage: "Duration must some hours and minutes") { value in
                    Int(value) != 0
            }
        }()

        lazy var formValidator: ValidationContainer = {
            $form.inlineValidator(
                form: formValidation,
                errorMessage: "Form must not be empty and end with an 's'") { value in
                    !value.isEmpty && value.count > 2 && value.hasSuffix("s")
            }
        }()

        lazy var remainingValidator: ValidationContainer = {
            $remaining.inlineValidator(
                form: formValidation,
                errorMessage: "Remaining must be 1 or above") { value in
                    !value.isEmpty && !value.isNumber
            }
        }()

        var example: String {
            if let med = med {
                return med.medDisplay
            }
            return ""
        }

        init(dataController: DataController, med: Med?, add: Bool, hasRelationship: Bool) {
            self.med = med
            self.add = add
            self.hasRelationship = hasRelationship
            self.dataController = dataController

            let showValue = !add || DataController.useAddScreenDefaults

            if let med = med {
                title = showValue ? med.medTitle : ""
                defaultAmount = showValue ? med.medDefaultAmount : ""
                colour = med.medColor
                symbol = med.medSymbol
                dosage = showValue ? med.medDosage : ""
                durationDate = showValue ? med.medDuration : "0"
                durationGapDate = showValue ? med.medDurationGap : "0"
                measure = med.medMeasure
                form = showValue ? med.medForm : ""
                notes = showValue ? med.medNotes : ""
                remaining = showValue ? med.medRemaining : ""
            } else {
                title = ""
                defaultAmount = ""
                colour = MedDefault.color
                symbol = MedDefault.symbol
                dosage = ""
                durationDate = "0"
                durationGapDate = "0"
                measure = MedDefault.measure
                form = ""
                notes = ""
                remaining = ""
            }
        }

        func save() {
            update()
            dataController.save()
        }

        private func update() {
            // med.dose?.objectWillChange.send()

            if let med = med {
                update(med: med)
            } else if add {
                let med = Med(context: dataController.container.viewContext)
                MedDefault.setSensibleDefaults(med)
                update(med: med)
            }
        }

        private func update(med: Med) {
            med.title = title
            med.defaultAmount = NSDecimalNumber(string: defaultAmount)
            med.color = colour
            med.symbol = symbol
            med.dosage = NSDecimalNumber(string: dosage)
            med.durationSeconds = Int16(durationDate) ?? 0
            med.durationGapSeconds = Int16(durationGapDate) ?? 0
            med.measure = measure
            med.form = form
            med.notes = notes
            med.remaining = Int16(remaining) ?? MedDefault.remaining
        }

        func copyMed() {
            let newMed = Med(context: dataController.container.viewContext)
            update(med: newMed)
            newMed.title = InterpolatedStrings.medEditCopiedSuffix(title: newMed.medTitle)
            dataController.save()
        }

        func deleteMed() {
            if let med = med {
                let count = dataController.anyRelationships(for: [med])

                // INFO: If this med only has 1 relationship and we're
                // using hard delete, then delete this med. Otherwise
                // keep the med for use with other doses.
                if count == 1 || DataController.useHardDelete {
                    dataController.delete(med)
                } else {
                    update()
                    med.hidden = true
                }
            }
        }

        func navigationTitle(add: Bool) -> Strings {
            add
                ? Strings.medEditAddMed
                : Strings.medEditEditMed
        }
    }
}
