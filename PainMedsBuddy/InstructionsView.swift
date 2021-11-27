//
//  InstructionsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct InstructionsView: View {
    let showTakenInstructions: Bool
    
    let instructions: FetchRequest<Instruction>
    
    init(showTakenInstructions: Bool) {
        self.showTakenInstructions = showTakenInstructions
        
        instructions = FetchRequest<Instruction>(entity: Instruction.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Instruction.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "taken = %d", showTakenInstructions))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(instructions.wrappedValue) { instruction in
                    Section(header: Text(instruction.title ?? "")) {
                        Text(instruction.drug?.title ?? "")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(showTakenInstructions ? "Taken Meds" : "Meds to take")
        }
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        InstructionsView(showTakenInstructions: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
