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

    var doseTotalTimeSeconds: Int {
        Int(med?.durationSeconds ?? MedDefault.duration) + Int(med?.durationGapSeconds ?? MedDefault.durationGap)
    }

    var doseElapsedSeconds: Int {
        if elapsed == false {
            let nowDate = Date()
            return Int(nowDate.timeIntervalSince(doseTakenDate))
        }
        return 0
    }

    var doseShouldHaveElapsed: Bool {
        doseTotalTimeSeconds > doseElapsedSeconds
    }

    var doseElapsedDate: Date? {
        if elapsed == false {
            if let duration = med?.medTotalDuration {
                let modifiedDate = doseTakenDate.addingTimeInterval(TimeInterval(duration))

                return modifiedDate
            }
        }

        return nil
    }

    var doseFormattedTakenDate: String {
        if let date = takenDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        } else {
            return String(.commonNoDate)
        }
    }

    var doseFormattedMYTakenDate: String {
        if let date = takenDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        } else {
            return String(.commonNoDate)
        }
    }

    var doseTotalDosage: String {
        let temp = ((amount ?? DoseDefault.amount) as Decimal) * ((med?.dosage ?? MedDefault.dosage) as Decimal)
        return "\(temp)"
    }

    var doseCountDownSeconds: String {
        if elapsed == false {
            if let date = doseElapsedDate {
                let nowDate = Date()
                return Int(date.timeIntervalSince(nowDate)).secondsToTimeHMS
            }
        }
        return "0"
    }

    var doseDisplayFull: String {
        Dose.displayFull(amount: doseAmount,
                         dosage: med?.medDosage ?? "\(MedDefault.dosage)",
                         totalDosage: doseTotalDosage,
                         measure: med?.measure ?? "\(MedDefault.measure)",
                         form: med?.form ?? MedDefault.form)
    }

    var doseDisplay: String {
        // swiftlint:disable:next line_length
        "\(doseAmount) x \(med?.medDosage ?? "\(MedDefault.dosage)")\(med?.measure ?? "\(MedDefault.measure)") \(med?.form ?? MedDefault.form)"
    }

    public static func displayFull(
        amount: String,
        dosage: String,
        totalDosage: String,
        measure: String,
        form: String
    ) -> String {
        "\(amount) x \(dosage)\(measure) \(form) = \(totalDosage)\(measure)"
    }

    public static func < (lhs: Dose, rhs: Dose) -> Bool {
        lhs.doseFormattedTakenDate < rhs.doseFormattedTakenDate
    }

    static var example: Dose {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let dose = Dose(context: viewContext)
        dose.amount = 1
        dose.elapsed = true
        dose.takenDate = Date()

        return dose
    }
}
