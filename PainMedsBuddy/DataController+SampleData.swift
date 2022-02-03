//
//  DataController+SampleData.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AppCenterCrashes

extension DataController {
    struct Data: Codable {
        let meds: [MedicationItem]
        let doses: [DoseItem]

//        enum CodingKeys: String, CodingKey {
//            case meds, doses
//        }
    }

    struct MedicationItem: Codable {
        var title: String
        var dosage: Decimal
        var defaultAmount: Decimal
        var durationSeconds: Int16
        var lastTakeDate: Date?
        var hasDose: Bool

//        enum CodingKeys: String, CodingKey {
//            case title, dosage, defaultAmount, durationSeconds, lastTakeDate, hasDose
//        }
    }

    struct DoseItem: Codable {
        var amount: Decimal
        var elapsed: Bool
        var remindMe: Bool
        var takeDate: Date
        var softElapsedDate: Date

//        enum CodingKeys: String, CodingKey {
//            case amount, elapsed, remindMe, takeDate, softElapsedDate
//        }
    }

    /// Creates example meds and doses to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData(appStore: Bool, medsRequested: Int, medDosesRequired: Int) throws {
        let viewContext = container.viewContext

        let drugs: [MedicationItem] = [
            MedicationItem(
                title: "Paracetamol",
                dosage: 500,
                defaultAmount: 2,
                durationSeconds: (4 * 60) * 60,
                hasDose: true),
            MedicationItem(
                title: "Ibuprofen",
                dosage: 200,
                defaultAmount: 2,
                durationSeconds: (4 * 60) * 60,
                hasDose: true),
            MedicationItem(
                title: "Codeine",
                dosage: 30,
                defaultAmount: 2,
                durationSeconds: (4 * 60) * 60,
                hasDose: false),
        ]

        let maxMeds = appStore ? min(drugs.count, medsRequested) : medsRequested

        for medIndex in 0 ..< maxMeds {
            let drug = appStore ? drugs[medIndex] : drugs.randomElement()!

            // INFO: One to one relationship
            let med = Med(context: viewContext)
            med.title = drug.title
            med.notes = "Notes about taking \(drug.title) x \(drug.dosage) Pills"
            med.defaultAmount = NSDecimalNumber(decimal: drug.defaultAmount)
            med.dosage = NSDecimalNumber(decimal: drug.dosage)
            med.color = Med.colours.randomElement()
            med.measure = "mg"
            med.form = "Pills"
            med.remaining = NSDecimalNumber(value: Int16.random(in: 0 ... 99))
            med.durationSeconds = drug.durationSeconds
            med.durationGapSeconds = Int16("00:20:00".timeToSeconds)
            med.creationDate = Date().adding(days: -20)
            med.lastTakenDate = Date().adding(days: -20)
            med.symbol = Symbol.allSymbols.randomElement()?.id
            med.hidden = false

            if drug.hasDose {
                if medDosesRequired > 0 {
                    var takenDates = createSampleTakenDate(amount: medDosesRequired)
                    for _ in 1 ... medDosesRequired {
                        let dose = Dose(context: viewContext)
                        dose.med = med

                        let tempDefaultAmount: Int = Int("\(drug.defaultAmount)") ?? 0
                        let tempAmount = Int.random(in: 1 ... tempDefaultAmount)

                        let tempTaken: Date = takenDates.first!
                        dose.takenDate = tempTaken
                        if tempTaken > med.lastTakenDate! {
                            med.lastTakenDate = tempTaken
                        }

                        dose.elapsed = dose.doseElapsedDate == nil
                            ? true
                            : dose.doseElapsedDate! < Date()

                        dose.softElapsedDate = dose.doseSoftElapsedDate

                        dose.amount = NSDecimalNumber(value: tempAmount)
                        dose.details = "Notes about - \(drug.title) \(tempAmount) x \(drug.dosage)mg Pills"
                        dose.remindMe = true

                        takenDates.remove(at: 0)
                    }
                }
            }
        }

        try viewContext.save()
    }

    func createSampleTakenDate(amount: Int) -> [Date] {
        let tenDaysAgo = Date() - 10

        var takenDates = [Date]()
        takenDates.append(Date().adding(minutes: -Int.random(in: 10 ... 55)))
        takenDates.append(Date().adding(minutes: -Int.random(in: 60 ... 360)))
        takenDates.append(tenDaysAgo)

        if amount > 0 {
            for _ in 0 ... amount {
                takenDates.append(Date.random(in: tenDaysAgo ..< Date().adding(hours: -4)))
            }
        }
        return takenDates
    }

    func createSampleData(appStore: Bool) throws {
        try? createSampleData(
            appStore: appStore,
            medsRequested: 5,
            medDosesRequired: 4)
    }

    func handleSampleDataOptions(appStore: Bool) {
        do {
            if let parameter = CommandLine
                .arguments
                .joined(separator: " ")
                .extractedParameter
            {
                let strings: [String] = parameter.components(separatedBy: ",")
                let numbers: [Int] = strings.map { Int($0)! }
                let (meds, doses) = (numbers[0], numbers[1])
                if meds == 0, doses > 0 {
                    Crashes.trackError(NSError(), properties: [
                        "Position": "DataController.handleSampleDataOptions",
                        "ErrorLabel": "You can not create sample data with doses and no meds!",
                    ], attachments: nil)
                    fatalError("ERROR: You can not create sample data with doses and no meds!")
                } else if meds == 0, doses == 0 {
                    Crashes.trackError(NSError(), properties: [
                        "Position": "DataController.handleSampleDataOptions",
                        "ErrorLabel": "You can not create sample data with doses and no meds!",
                    ], attachments: nil)
                    fatalError("ERROR: You can not create sample data with no doses and no meds!")
                }
                try createSampleData(
                    appStore: appStore,
                    medsRequested: meds,
                    medDosesRequired: doses)
            } else {
                try createSampleData(appStore: appStore)
            }
        } catch {
            Crashes.trackError(error, properties: [
                "Position": "DataController.handleSampleDataOptions",
                "ErrorLabel": "Fatal error creating data",
            ], attachments: nil)
            fatalError("Fatal error creating data: \(error.localizedDescription)")
        }
    }

    func coreDataToJson() {
        let tempData = Data(meds: [], doses: [])

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(tempData)
            print(String(data: data, encoding: .utf8)!)
        } catch {}
    }

    func jsonToCoreData() {
        let jsonString = ""

        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            let data = try decoder.decode(Data.self, from: jsonData)
            print(data)
        } catch {}
    }
}
