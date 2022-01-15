//
//  MedEditViewModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import Foundation

extension MedEditView {
    class ViewModel: NSObject, ObservableObject {
        let med: Med
        let add: Bool
        let hasRelationship: Bool

        private let dataController: DataController

        @Published var title: String
        @Published var defaultAmount: String
        @Published var colour: String
        @Published var symbol: String
        @Published var dosage: String
        @Published var durationDate: Int
        @Published var durationGapDate: Int
        @Published var measure: String
        @Published var form: String
        @Published var notes: String
        @Published var remaining: String

        init(dataController: DataController, med: Med, add: Bool, hasRelationship: Bool) {
            self.med = med
            self.add = add
            self.hasRelationship = hasRelationship
            self.dataController = dataController

            let showValue = !add || DataController.useAddScreenDefaults

            title = showValue ? med.medTitle : ""
            defaultAmount = showValue ? med.medDefaultAmount : ""
            colour = showValue ? med.medColor : ""
            symbol = showValue ? med.medSymbol : ""
            dosage = showValue ? med.medDosage : ""
            durationDate = showValue ? Int(med.durationSeconds) : 0
            durationGapDate = showValue ? Int(med.durationGapSeconds) : 0
            measure = showValue ? med.medMeasure : ""
            form = showValue ? med.medForm : ""
            notes = showValue ? med.medNotes : ""
            remaining = showValue ? med.medRemaining : ""
        }

        func update() {
            // med.dose?.objectWillChange.send()

            update(med: med)
        }

        func update(med: Med) {
            med.title = title
            med.defaultAmount = NSDecimalNumber(string: defaultAmount)
            med.color = colour
            med.symbol = symbol
            med.dosage = NSDecimalNumber(string: dosage)
            med.durationSeconds = Int16(durationDate)
            med.durationGapSeconds = Int16(durationGapDate)
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

        func navigationTitle(add: Bool) -> Strings {
            add
                ? Strings.medEditAddMed
                : Strings.medEditEditMed
        }
    }
}
