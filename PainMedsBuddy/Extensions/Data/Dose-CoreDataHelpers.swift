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

    var doseDetails: String {
        details ?? DoseDefault.details
    }

    var doseTotalTimeSeconds: Int {
        if let med = med {
            let total = Int(med.durationSeconds) + Int(med.durationGapSeconds)
            return total
        }
        return 0
    }

    var doseElapsedSeconds: Int {
        if elapsed == false {
            let nowDate = Date()
            let seconds = Int(nowDate.timeIntervalSince(doseTakenDate))
            return seconds
        }
        return 0
    }

    var doseShouldHaveElapsed: Bool {
        doseElapsedSeconds > doseTotalTimeSeconds
    }

    var doseElapsedDate: Date? {
        if elapsed == false {
            if let duration = med?.medTotalDurationSeconds {
                let modifiedDate = doseTakenDate.addingTimeInterval(TimeInterval(duration))

                return modifiedDate
            }
        }

        return nil
    }

    var doseFormattedTakenDateLong: String {
        if let date = takenDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-dd-MM"
            dateFormatter.locale = Locale.current
            return dateFormatter.string(from: date)
        }

        return String(.commonNoDate)
    }

    var doseFormattedTakenDateMedium: String {
        if let date = takenDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, dd MMMM yyyy HH:mm"
            dateFormatter.locale = Locale.current
            return dateFormatter.string(from: date)
        }

        return String(.commonNoDate)
    }

    var doseFormattedTakenTimeShort: String {
        if let date = takenDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
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
        }
        return String(.commonNoDate)
    }

    var doseTotalDosage: String {
        let temp = ((amount ?? DoseDefault.amount) as Decimal) * ((med?.dosage ?? MedDefault.dosage) as Decimal)
        return "\(temp)"
    }

    func doseCountDownSeconds(nowDate: Date) -> String {
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
        let tempDosage = med?.medDosage ?? "\(MedDefault.dosage)"
        let tempMeasure = med?.measure ?? "\(MedDefault.measure)"
        let tempForm = med?.form ?? MedDefault.form

        return "\(doseAmount) x \(tempDosage)\(tempMeasure) \(tempForm)"
    }

    var doseSearchableDisplay: String {
        // name amount x dosage measure form
        let tempName = med?.medTitle ?? MedDefault.title
        let tempDosage = med?.medDosage ?? "\(MedDefault.dosage)"
        let tempMeasure = med?.measure ?? "\(MedDefault.measure)"
        let tempForm = med?.form ?? MedDefault.form

        return "\(tempName) - \(doseAmount) x \(tempDosage)\(tempMeasure) \(tempForm)"
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
        lhs.doseFormattedTakenTimeShort < rhs.doseFormattedTakenTimeShort
    }

    static var example: Dose {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let dose = Dose(context: viewContext)
        dose.amount = 1
        dose.elapsed = true
        dose.takenDate = Date()
        dose.details = "This is an example dose"

        return dose
    }
}
