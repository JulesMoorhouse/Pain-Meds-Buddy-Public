//
//  DataController+SampleData.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AppCenterCrashes

extension DataController {
    /// Creates example meds and doses to make manual testing easier.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData(appStore: Bool, medsRequested: Int, medDosesRequired: Int) throws {
        let viewContext = container.viewContext

        struct Drug {
            var name = ""
            var mGrams = 0
            var defAmt: Int16 = 0
            var duration: Int16 = 0
            var lastTakeDate = Date()
            var hasDose: Bool
        }

        let drugs: [Drug] = [
            Drug(name: "Paracetamol", mGrams: 500, defAmt: 2, duration: (4 * 60) * 60, hasDose: true),
            Drug(name: "Ibuprofen", mGrams: 200, defAmt: 2, duration: (4 * 60) * 60, hasDose: true),
            Drug(name: "Codeine", mGrams: 30, defAmt: 2, duration: (4 * 60) * 60, hasDose: false),
        ]

        let maxMeds = appStore ? min(drugs.count, medsRequested) : medsRequested

        for medIndex in 0 ..< maxMeds {
            let drug = appStore ? drugs[medIndex] : drugs.randomElement()!

            // INFO: One to one relationship
            let med = Med(context: viewContext)
            med.title = drug.name
            med.notes = "Notes about taking \(drug.name) x \(drug.mGrams) Pills"
            med.defaultAmount = NSDecimalNumber(value: drug.defAmt)
            med.dosage = NSDecimalNumber(value: drug.mGrams)
            med.color = Med.colours.randomElement()
            med.measure = "mg"
            med.form = "Pills"
            med.remaining = NSDecimalNumber(value: Int16.random(in: 0 ... 99))
            med.durationSeconds = drug.duration
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

                        let tempAmount = Int16.random(in: 1 ... drug.defAmt)

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
                        dose.details = "Notes about - \(drug.name) \(tempAmount) x \(drug.mGrams)mg Pills"
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
            medDosesRequired: 4
        )
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
                    medDosesRequired: doses
                )
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
}
