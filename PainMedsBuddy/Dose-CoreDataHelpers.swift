//
//  Dose-CoreDataHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Dose: Comparable {
    var doseAmount: String {
        "\(String(describing: amount ?? DoseDefault.amount))"
    }

    var doseTakenDate: Date {
        takenDate ?? DoseDefault.takenDate
    }

    var doseElapsed: Bool {
        elapsed
    }

    // ---
    var doseTotalTime: Int {
        Int(self.med?.duration ?? MedDefault.duration) + Int(self.med?.durationGap ?? MedDefault.durationGap)
    }

    var doseElapsedDate: Date? {
        if elapsed == false {
            if let duration = self.med?.medTotalDuration {
                let modifiedDate = self.doseTakenDate.addingTimeInterval(TimeInterval(duration))

                return modifiedDate
            }
        }

        return nil
    }

    var doseElapsedInt: Int {
        if elapsed == false {
            return Int(Date().timeIntervalSince(self.doseTakenDate))
        }
        return 0
    }

    var doseShowHaveElapsed: Bool {
        if elapsed == false {
            if let date = self.doseElapsedDate {
                return date <= Date()
            }
        }

        return false
    }

    var doseTimeRemainingInt: Int {
        if elapsed == false {
            if let date = self.doseElapsedDate {
                return Int(date.timeIntervalSince(Date()))
            }
        }
        return 0
    }

    // ---
    var doseFormattedTakenDate: String {
        if let date = takenDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else {
            return "No date"
        }
    }

    var doseFormattedMYTakenDate: String {
        if let date = takenDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        } else {
            return "No date"
        }
    }

    var doseTotalDosage: String {
        let temp = ((amount ?? DoseDefault.amount) as Decimal) * ((self.med?.dosage ?? MedDefault.dosage) as Decimal)
        return "\(temp)"
    }

    var doseDisplayFull: String {
        return Dose.displayFull(amount: self.doseAmount,
                                dosage: self.med?.medDosage ?? "\(MedDefault.dosage)",
                                totalDosage: self.doseTotalDosage,
                                measure: self.med?.measure ?? "\(MedDefault.measure)",
                                form: self.med?.form ?? MedDefault.form)
    }

    var doseDisplay: String {
        "\(self.doseAmount) x \(self.med?.medDosage ?? "\(MedDefault.dosage)")\(self.med?.measure ?? "\(MedDefault.measure)") \(self.med?.form ?? MedDefault.form)"
    }

    public static func displayFull(amount: String, dosage: String, totalDosage: String, measure: String, form: String) -> String {
        return "\(amount) x \(dosage)\(measure) \(form) = \(totalDosage)\(measure)"
    }

    public static func < (lhs: Dose, rhs: Dose) -> Bool {
        lhs.doseFormattedTakenDate < rhs.doseFormattedTakenDate
    }

    static var example: Dose {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let dose = Dose(context: viewContext)
        dose.amount = 1
        dose.elapsed = true
        dose.takenDate = Date()

        return dose
    }
}
