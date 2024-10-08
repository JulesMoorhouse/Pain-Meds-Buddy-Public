//
//  DataController+ImportExport.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import Foundation

extension DataController {
    struct Data: Codable {
        var meds: [MedicationItem]
        var doses: [DoseItem]
    }

    struct MedicationItem: Codable {
        var objectID: String?
        var title: String
        var dosage: Decimal
        var defaultAmount: Decimal
        var durationSeconds: Int16
        var lastTakeDate: Date?
        var hasDose: Bool
        var notes: String?
        var color: String?
        var measure: String?
        var form: String?
        var remaining: Decimal?
        var durationGapSeconds: Int16
        var creationDate: Date?
        var symbol: String?
        var hidden: Bool

        init(title: String,
             dosage: Decimal,
             defaultAmount: Decimal,
             durationSeconds: Int16,
             hasDose: Bool)
        {
            self.title = title
            self.dosage = dosage
            self.defaultAmount = defaultAmount
            self.durationSeconds = durationSeconds
            self.hasDose = hasDose

            self.notes = ""
            self.color = ""
            self.measure = ""
            self.form = ""
            self.remaining = 100
            self.durationGapSeconds = 0
            self.creationDate = Date()
            self.symbol = ""
            self.hidden = false
        }

        init(med: Med) {
            self.objectID = med.objectID.uriRepresentation().absoluteString
            self.title = med.medTitle
            self.dosage = med.medDosageDecimal
            self.defaultAmount = med.medDefaultAmountDecimal
            self.durationSeconds = med.durationSeconds
            self.lastTakeDate = med.medLastTakenDate
            self.hasDose = med.dose != nil
            self.notes = med.notes
            self.color = med.color
            self.measure = med.measure
            self.form = med.form
            self.remaining = med.remaining as Decimal?
            self.durationGapSeconds = med.durationGapSeconds
            self.creationDate = med.creationDate
            self.symbol = med.symbol
            self.hidden = med.hidden
        }

        func setMed(med: Med) {
            med.title = title
            med.dosage = NSDecimalNumber(decimal: dosage)
            med.defaultAmount = NSDecimalNumber(decimal: defaultAmount)
            med.durationSeconds = durationSeconds
            med.lastTakenDate = lastTakeDate
            med.notes = notes
            med.color = color
            med.measure = measure
            med.form = form
            med.remaining = remaining as NSDecimalNumber?
            med.durationGapSeconds = durationGapSeconds
            med.creationDate = creationDate
            med.symbol = symbol
            med.hidden = hidden
        }
    }

    struct DoseItem: Codable {
        var medObjectID: String?
        var amount: Decimal
        var elapsed: Bool
        var remindMe: Bool
        var takeDate: Date
        var softElapsedDate: Date?

        init(dose: Dose) {
            self.medObjectID = dose.med!.objectID.uriRepresentation().absoluteString
            self.amount = (dose.amount ?? 0.0) as Decimal
            self.elapsed = dose.elapsed
            self.remindMe = dose.remindMe
            self.takeDate = dose.doseTakenDate
            self.softElapsedDate = dose.softElapsedDate
        }

        func setDose(dose: Dose) {
            dose.amount = NSDecimalNumber(decimal: amount)
            dose.elapsed = elapsed
            dose.remindMe = remindMe
            dose.takenDate = takeDate
            dose.softElapsedDate = softElapsedDate
        }
    }

    func coreDataToJson() throws -> String {
        var tempData = Data(meds: [], doses: [])

        let medRequest = NSFetchRequest<Med>(entityName: "Med")
        let tempMeds = try container.viewContext.fetch(medRequest)
        for med in tempMeds {
            let medItem = MedicationItem(med: med)
            tempData.meds.append(medItem)
        }

        let doseRequest = NSFetchRequest<Dose>(entityName: "Dose")
        let tempDoses = try container.viewContext.fetch(doseRequest)
        for dose in tempDoses {
            let doseItem = DoseItem(dose: dose)
            tempData.doses.append(doseItem)
        }

        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        encoder.dateEncodingStrategy = .formatted(formatter)

        encoder.outputFormatting = .prettyPrinted

        var result = ""

        let data = try encoder.encode(tempData)
        // swiftlint:disable non_optional_string_data_conversion
        result = String(data: data, encoding: .utf8)!
        // swiftlint:enable non_optional_string_data_conversion
    
        return result
    }

    func jsonToCoreData(_ jsonString: String) throws {
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)

        do {
            let viewContext = container.viewContext

            let data = try decoder.decode(Data.self, from: jsonData)

            deleteAll()

            for medItem in data.meds {
                let med = Med(context: viewContext)
                medItem.setMed(med: med)
                med.title = "\(med.medTitle)"

                let medDoses = data.doses.filter {
                    $0.medObjectID == medItem.objectID
                }

                for doseItem in medDoses {
                    let tempDose = Dose(context: viewContext)
                    doseItem.setDose(dose: tempDose)
                    tempDose.med = med
                }
            }
            try viewContext.save()

        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
