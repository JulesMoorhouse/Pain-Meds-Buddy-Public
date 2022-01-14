//
//  MedEditViewModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CoreData
import Foundation

extension MedEditView {
    class ViewModel: NSObject, ObservableObject {
        let med: Med
        let add: Bool
        let hasRelationship: Bool

        private let dataController: DataController

        init(dataController: DataController, med: Med, add: Bool, hasRelationship: Bool) {
            self.med = med
            self.add = add
            self.hasRelationship = hasRelationship
            self.dataController = dataController
        }
    }
}
