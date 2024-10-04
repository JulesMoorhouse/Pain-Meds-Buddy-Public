//
//  DataController+SampleData.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData

extension DataController {
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
            med.remaining = medIndex == 0 ? 2
                : NSDecimalNumber(value: Int16.random(in: 0 ... 99))
            med.durationSeconds = drug.durationSeconds
            med.durationGapSeconds = Int16("00:20:00".timeToSeconds)
            med.creationDate = Date().adding(days: -20)
            med.lastTakenDate = Date().adding(days: -20)
            med.symbol = SymbolModel.allSymbols.randomElement()?.id
            med.hidden = false

            if drug.hasDose {
                if medDosesRequired > 0 {
                    var takenDates = createSampleTakenDate(amount: medDosesRequired)
                    for _ in 1 ... medDosesRequired {
                        let dose = Dose(context: viewContext)
                        dose.med = med

                        let tempDefaultAmount = Int("\(drug.defaultAmount)") ?? 0
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
                    fatalError("ERROR: You can not create sample data with doses and no meds!")
                } else if meds == 0, doses == 0 {
                    self.processArgumentsForTesting()
                } else {
                    try createSampleData(
                        appStore: appStore,
                        medsRequested: meds,
                        medDosesRequired: doses)
                }
            } else {
                try createSampleData(appStore: appStore)
            }
        } catch {
            fatalError("Fatal error creating data: \(error.localizedDescription)")
        }
    }
}
