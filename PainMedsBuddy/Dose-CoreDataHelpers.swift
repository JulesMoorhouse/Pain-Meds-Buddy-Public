//
//  Dose-CoreDataHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Dose: Comparable {
    var doseAmount: String {
        "\(String(describing: amount ?? 0.0))"
    }

    var doseTakenDate: Date {
        takenDate ?? Date()
    }

    var doseElapsed: Bool {
        elapsed
    }

    // ---
    var doseTotalTime: Int {
        Int(self.med?.duration ?? 0) + Int(self.med?.durationGap ?? 0)
    }

    var doseElapsedDate: Date? {
        if elapsed == false {
            if let duration = self.med?.medTotalDuration {
                //let (hours, minutes, _) = duration.secondsToHoursMinutesSeconds

                let modifiedDate = self.doseTakenDate.addingTimeInterval(TimeInterval(duration))
                
                //var modifiedDate: Date = Calendar.current.date(byAdding: .hour, value: hours, to: self.doseTakenDate)

                //modifiedDate = Calendar.current.date(byAdding: .minute, value: minutes, to: modifiedDate)

                return modifiedDate
            }
        }

        return nil
    }

    var doseShowHaveElapsed: Bool {
        if elapsed == false {
            if let date = self.doseElapsedDate {
                return date <= Date()
            }
        }

        return false
    }

    var doseTimeRemaining: Int {
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
        let temp = ((amount ?? 0.0) as Decimal) * ((self.med?.dosage ?? 0) as Decimal)
        return "\(temp)"
    }

    var doseDisplayFull: String {
        return Dose.displayFull(amount: self.doseAmount,
                                dosage: self.med?.medDosage ?? "0",
                                totalDosage: self.doseTotalDosage,
                                measure: self.med?.measure ?? "",
                                form: self.med?.form ?? "")
    }

    var doseDisplay: String {
        "\(self.doseAmount) x \(self.med?.medDosage ?? "0")\(self.med?.measure ?? "") \(self.med?.form ?? "")"
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
