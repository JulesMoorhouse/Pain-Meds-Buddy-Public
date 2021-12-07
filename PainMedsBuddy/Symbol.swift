//
//  Symbol.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

struct Symbol: Decodable, Identifiable {
    var id: String { name }
    let name: String
    
    static let allSymbols = Bundle.main.decode([Symbol].self, from: "Symbols.json")
    static let example = allSymbols[0]
}
