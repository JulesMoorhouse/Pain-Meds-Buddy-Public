//
//  DosesView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view shows all the taken doses of medication

import CoreData
import SwiftUI
import XNavigation

struct DosesView: View {
    static let inProgressTag: String? = "InProgress"
    static let historyTag: String? = "History"

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var navigation: Navigation

    let showElapsedDoses: Bool
    let doses: FetchRequest<Dose>

    var medsCount: Int {
        let fetchRequest = NSFetchRequest<Med>(entityName: "Med")
        return dataController.count(for: fetchRequest)
    }

    init(dataController _: DataController, showElapsedDoses: Bool) {
        self.showElapsedDoses = showElapsedDoses

        doses = FetchRequest<Dose>(entity: Dose.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Dose.takenDate, ascending: true),
        ], predicate: NSPredicate(format: "elapsed = %d", showElapsedDoses))
    }

    // INFO: Results to an array of section arrays
    func resultsToArray(_ result: FetchedResults<Dose>) -> [[Dose]] {
        let dict = Dictionary(grouping: result) { (sequence: Dose) in
            sequence.doseFormattedMYTakenDate
        }

        // INFO: Sort by key aka doseFormattedMYTakenDate
        let sorted = dict.sorted(by: { $0.key > $1.key })

        return sorted.map(\.value)
    }

    func rowsView(section: [Dose]) -> some View {
        ForEach(section, id: \.self) { dose in
            DoseRowView(dose: dose)
        }
        .onDelete { offsets in
            deleteDose(offsets, from: section)
        }
    }

    var body: some View {
        let data: [[Dose]] = resultsToArray(self.doses.wrappedValue)

        return NavigationView {
            Group {
                if data.isEmpty {
                    PlaceholderView(string: placeHolderEmptyText(),
                                    imageString: SFSymbol.pills.systemName)
                } else {
                    List {
                        ForEach(data, id: \.self) { (section: [Dose]) in
                            Section(header: Text(section[0].doseFormattedMYTakenDate)) {
                                self.rowsView(section: section)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle(navigationTitle().rawValue)
            .navigationBarAccessibilityIdentifier(navigationTitle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if medsCount > 0 {
                        HStack {
                            Text("")
                                .accessibilityHidden(true)

                            Button(action: {
                                navigation.pushView(DoseAddView(med: dataController.createMed())
                                    .environment(\.managedObjectContext, managedObjectContext)
                                    .environmentObject(dataController))
                            }, label: {
                                // INFO: In iOS 14.3 VoiceOver has a glitch that reads the label
                                // "Add Dose" as "Add" no matter what accessibility label
                                // we give this toolbar button when using a label.
                                // As a result, when VoiceOver is running, we use a text
                                // view for the button instead, forcing a correct reading
                                // without losing the original layout.
                                if UIAccessibility.isVoiceOverRunning {
                                    Text(.doseEditAddDose)
                                        .accessibilityIdentifier(.doseEditAddDose)

                                } else {
                                    Label(.doseEditAddDose, systemImage: SFSymbol.plus.systemName)
                                        .accessibilityElement()
                                        .accessibility(addTraits: .isButton)
                                        .accessibilityIdentifier(.doseEditAddDose)
                                }
                            })
                        }
                    }
                }
            }

            PlaceholderView(string: placeHolderText(),
                            imageString: SFSymbol.eyeDropperHalfFull.systemName)
        }
    }

    func placeHolderText() -> Strings {
        medsCount > 0
            ? .commonPleaseSelect
            : .commonPleaseAdd
    }

    func navigationTitle() -> Strings {
        showElapsedDoses
            ? .tabTitleHistory
            : .tabTitleInProgress
    }

    func placeHolderEmptyText() -> Strings {
        medsCount > 0
            ? .commonEmptyView
            : .commonPleaseAdd
    }

    func deleteDose(_ offsets: IndexSet, from doses: [Dose]) {
        for offset in offsets {
            let item = doses[offset]
            dataController.delete(item)
        }
        dataController.save()
        dataController.container.viewContext.processPendingChanges()
    }
}

struct DosesView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        DosesView(dataController: dataController, showElapsedDoses: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
