//
//  EditDoseView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// This view allows editing of the dose and selection / re-selection of a med

//import CoreData
//import SwiftUI
//
//struct EditDoseView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest private var items: FetchedResults<Dose>
//    @State private var selection = Dose()
//
//    init(dose: Dose) {
//        let fetchRequest: NSFetchRequest<Dose> = Dose.fetchRequest()
//        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Dose.doseTakenDate, ascending: false)]
//        fetchRequest.predicate = NSPredicate(value: true)
//        self._items = FetchRequest(fetchRequest: fetchRequest)
//        do {
//            let tempItems = try viewContext.fetch(fetchRequest)
//            if(tempItems.count > 0) {
//                self._selection = State(initialValue: tempItems.first!)
//            } else {
//                self._selection = State(initialValue: Dose(context: viewContext))
//                viewContext.delete(selection)
//            }
//        } catch {
//            fatalError("Init Problem")
//        }
//    }
//
//    var body: some View {
//        VStack {
//            if (items.count > 0) {
//                Picker("Items", selection: $selection) {
//                    ForEach(items) { (item: Dose) in
//                        Text(item.doseTitle).tag(item)
//                    }
//                }.padding()
//            }
////            .toolbar {
////                Button(action: addItem) {
////                    Label("Add Item", systemImage: "plus")
////                }
////            }
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Dose(context: viewContext)
//            newItem.takenDate = Date()
//            do {
//                try viewContext.save()
//                selection = newItem //This automatically changes your selection when you add a new item.
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//}


import CoreData
import SwiftUI

struct EditDoseView: View {
    let dose: Dose

    //@Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataController: DataController

    @State private var takenDate: Date
    @State private var selectedMed = Med()

    @FetchRequest private var meds: FetchedResults<Med>

    init(dose: Dose) {
        self.dose = dose

        //var tempSelection: Med?

        _takenDate = State(wrappedValue: dose.doseTakenDate)

        let fetchRequest: NSFetchRequest<Med> = Med.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Med.sequence, ascending: false)
        ]

        self._meds = FetchRequest(fetchRequest: fetchRequest)

        if let currentMed = dose.med {
            //tempSelection = currentMed
            self._selectedMed = State(initialValue: currentMed)

        } else {
            do {
                let tempMeds = try dataController.container.viewContext.fetch(fetchRequest)
                if (tempMeds.count > 0) {
                    //tempSelection = tempMeds.first
                    self._selectedMed = State(initialValue: tempMeds.first!)

                    
                } else {
                    self._selectedMed = State(initialValue: Med(context: dataController.container.viewContext))
                    dataController.container.viewContext.delete(selectedMed)
                }
            } catch {
                fatalError("Error loading data")
            }
        }

       // self._selectedMed = State(initialValue: tempSelection!)

        _takenDate = State(wrappedValue: dose.doseTakenDate)

    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {

                DatePicker("Please enter a time", selection: $takenDate, displayedComponents: .hourAndMinute)
                    //.labelsHidden()
                    //.datePickerStyle(WheelDatePickerStyle())

                Picker("Medication", selection: $selectedMed.onChange(update)) {
                    ForEach(meds) { (thisMed: Med) in
                       // NavigationLink(destination: EditDoseMedView(dose: dose, med: thisMed)) {
                        //HStack {
                            Text(thisMed.medDefaultTitle)
                          //  Spacer()
                           // Text("\(thisMed.remaining)")
                    //    }
                    .tag(thisMed)
                       // }
                    }
                }

            }
            .navigationTitle("Edit Dose")
            .onDisappear(perform: dataController.save)
        }
    }

    func update() {
        dose.objectWillChange.send()

        dose.takenDate = takenDate
        dose.med = selectedMed
    }
}

struct EditDoseView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        EditDoseView(dose: Dose.example)
    }
}
