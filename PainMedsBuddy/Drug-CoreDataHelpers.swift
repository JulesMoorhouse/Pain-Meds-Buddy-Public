//
//  Drug-CoreDataHelpers.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Drug {
    var drugTitle: String {
        title ?? ""
    }
    
    var drugDetail: String {
        detail ?? ""
    }
    
    var drugCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Drug {
        let controller =  DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let drug = Drug(context: viewContext)
        drug.title = "Example med"
        drug.detail = "This is an exmaple med"
        drug.priority = 3
        drug.creationDate = Date()
        
        return drug
    }
}
