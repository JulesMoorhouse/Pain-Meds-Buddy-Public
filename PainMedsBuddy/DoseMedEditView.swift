////
////  DoseMedEditView.swift
////  PainMedsBuddy
////
////  Created by Jules Moorhouse.
////
//// This view allow editing of the medicatioon assigned to the dose.
//// Also is links to the master medication record to show remaining
//// mediation items (e.g. 10 pill)
//
//import SwiftUI
//
//// NOT USED
//
//struct DoseMedEditView: View {
//    let dose: Dose
//    let med: Med
//    
//    @EnvironmentObject var dataController: DataController
//    
//    let types = ["mg", "ml", "pills"]
//
//    @State private var title: String
//    @State private var unit: String
//    @State private var amount: Decimal
//    @State private var remaining: Int
//
//    init(dose: Dose, med: Med) {
//        self.dose = dose
//        self.med = med
//        
//        _title = State(wrappedValue: dose.doseTitle)
//        _amount = State(wrappedValue: dose.doseAmount)
//        _remaining = State(wrappedValue: Int(dose.med?.remaining ?? 0))
//    }
//    
//    var body: some View {
//        Form {
//            Section(header: Text("Basic settings")) {
//                TextField("Text", text: $title.onChange(update))
//                
//                Picker("Unit", selection: $unit.onChange(update)) {
//                    ForEach(types, id: \.self) {
//                        Text($0)
//                    }
//                }
//                
//                TextField("Amount", value: $amount.onChange(update), formatter: NumberFormatter())
//                
//                TextField("Remaining", value: $remaining.onChange(update), formatter: NumberFormatter())
//
//            }
//        }
//        .navigationTitle("Edit Dose")
//        .onDisappear(perform: dataController.save)
//    }
//    
//    func update() {
//        dose.objectWillChange.send()
//        
//        dose.title = title
//        dose.amount = NSDecimalNumber(decimal: amount)
//        dose.taken = true
//        dose.takenDate = Date()
//        
//        dose.med?.remaining = Int16(remaining)
//    }
//}
//
//struct DoseMedEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        DoseMedEditView(dose: Dose.example, med: Med.example)
//    }
//}
