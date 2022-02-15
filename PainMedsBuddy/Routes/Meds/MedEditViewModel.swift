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
        var dataChanged: Bool = false

        private let dataController: DataController

        @Published var title: String {
            didSet(oldValue) {
                if title != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var defaultAmount: String {
            didSet(oldValue) {
                if defaultAmount != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var colour: String {
            didSet(oldValue) {
                if colour != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var symbol: String {
            didSet(oldValue) {
                if symbol != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var dosage: String {
            didSet(oldValue) {
                if dosage != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var durationDate: String {
            didSet(oldValue) {
                if durationDate != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var durationGapDate: String {
            didSet(oldValue) {
                if durationGapDate != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var measure: String {
            didSet(oldValue) {
                if measure != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var form: String {
            didSet(oldValue) {
                if form != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var notes: String {
            didSet(oldValue) {
                if notes != oldValue {
                    dataChanged = true
                }
            }
        }

        @Published var remaining: String {
            didSet(oldValue) {
                if remaining != oldValue {
                    dataChanged = true
                }
            }
        }

        lazy var formValidation: FormValidation = .init(validationType: .immediate)

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
                errorMessage: message
            ) { value in
                !value.isEmpty && value.count > 1 && value.count <= 30
            }
        }()

        lazy var defaultAmountValidator: ValidationContainer = {
            var field = String(.medEditDefaultAmount)
            let message = String(.validationOneOrAbove,
                                 values: [field])

            return $defaultAmount.inlineValidator(
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

        lazy var dosageValidator: ValidationContainer = {
            var field = String(.commonDosage)
            let message = String(.validationOneOrAbove,
                                 values: [field])

            return $dosage.inlineValidator(
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

        lazy var durationDateValidator: ValidationContainer = {
            var field = String(.medEditDuration)
            let message = String(.validationMustSpecify,
                                 values: [field])

            return $durationDate.inlineValidator(
                form: formValidation,
                errorMessage: message
            ) { value in
                Int(value) != 0
            }
        }()

        lazy var formValidator: ValidationContainer = {
            var field = String(.medEditForm)
            let message = String(.validationMustEmpty,
                                 values: [field])

            return $form.inlineValidator(
                form: formValidation,
                errorMessage: message
            ) { value in
                !value.isEmpty && value.count > 1 && value.count <= 10
            }
        }()

        lazy var remainingValidator: ValidationContainer = {
            var field = String(.medEditRemaining)
            let message = String(.validationZeroOrAbove,
                                 values: [field])

            return $remaining.inlineValidator(
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

        var example: String {
            let amount: Int = defaultAmount.isNumber ? Int(defaultAmount) ?? 0 : 0
            let dose: Int = dosage.isNumber ? Int(dosage) ?? 0 : 0
            let formWord = Med.formWord(num: amount, word: form)
            return "\(amount) x \(dose)\(measure) \(formWord) = \(amount * dose)\(measure)"
        }

        // MARK: -

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
                form = showValue ? med.medFormPlural : ""
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

            if let tempMed = med {
                update(item: tempMed)
            } else if add {
                let med = Med(context: dataController.container.viewContext)
                med.setSensible()
                update(item: med)
            }
        }

        private func update(item: Med) {
            item.title = title
            item.defaultAmount = NSDecimalNumber(string: defaultAmount)
            item.color = colour
            item.symbol = symbol
            item.dosage = NSDecimalNumber(string: dosage)
            item.durationSeconds = Int16(durationDate) ?? 0
            item.durationGapSeconds = Int16(durationGapDate) ?? 0
            item.measure = measure
            item.form = form
            item.notes = notes
            item.remaining = NSDecimalNumber(string: remaining)
        }

        func copyMed() {
            let newMed = Med(context: dataController.container.viewContext)
            update(item: newMed)
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
                    dataController.save()
                }
            }
        }

        func deleteMedDoseHistory() {
            if let med = med {
                let tempDoses = dataController.getMedDoses(for: med, elapsed: true)
                for dose in tempDoses {
                    dataController.delete(dose)
                }
                dataController.save()
            }
        }

        func navigationTitle(add: Bool) -> Strings {
            add
                ? Strings.medEditAddMed
                : Strings.medEditEditMed
        }
    }
}
