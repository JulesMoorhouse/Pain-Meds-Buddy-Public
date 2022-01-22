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

        // INFO: Validator need to return false to return a red
        // message in the ui. Therefore, the logic must return
        // false if there's a problem
        lazy var titleValidator: ValidationContainer = {
            var field = String(.medEditTitle)
            let message = String(.validationTwoLetters,
                                 values: [field])

            return $title.inlineValidator(
                form: formValidation,
                errorMessage: message) { value in
                    !value.isEmpty && value.count > 2
            }
        }()

        lazy var defaultAmountValidator: ValidationContainer = {
            var field = String(.medEditDefaultAmount)
            let message = String(.validationOneOrAbove,
                                 values: [field])

            return $defaultAmount.inlineValidator(
                form: formValidation,
                errorMessage: message) { value in
                    value.isNumber && (Int(value) ?? 0) > 0
            }
        }()

        lazy var dosageValidator: ValidationContainer = {
            var field = String(.commonDosage)
            let message = String(.validationOneOrAbove,
                                 values: [field])

            return $dosage.inlineValidator(
                form: formValidation,
                errorMessage: message) { value in
                    value.isNumber && (Int(value) ?? 0) > 0
            }
        }()

        lazy var durationDateValidator: ValidationContainer = {
            var field = String(.medEditDuration)
            let message = String(.validationMustSpecify,
                                 values: [field])

            return $durationDate.inlineValidator(
                form: formValidation,
                errorMessage: message) { value in
                    Int(value) != 0
            }
        }()

        lazy var formValidator: ValidationContainer = {
            var field = String(.medEditForm)
            let message = String(.validationMustEmptySuffixS,
                                 values: [field])

            return $form.inlineValidator(
                form: formValidation,
                errorMessage: message) { value in
                    !value.isEmpty && value.count > 1 && value.hasSuffix("s")
            }
        }()

        lazy var remainingValidator: ValidationContainer = {
            var field = String(.medEditRemaining)
            let message = String(.validationOneOrAbove,
                                 values: [field])

            return $remaining.inlineValidator(
                form: formValidation,
                errorMessage: message) { value in
                    value.isNumber && (Int(value) ?? 0) > 0
            }
        }()

        var example: String {
            let amount: Int = defaultAmount.isNumber ? Int(defaultAmount) ?? 0 : 0
            let dose: Int = dosage.isNumber ? Int(dosage) ?? 0 : 0
            return "\(amount) x \(dose)\(measure) \(form) = \(amount * dose)\(measure)"
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
                durationDate = showValue ? med.medDurationSeconds : "0"
                durationGapDate = showValue ? med.medDurationGapSeconds : "0"
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
