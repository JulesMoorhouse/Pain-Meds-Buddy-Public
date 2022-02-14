//
//  SymbolModel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

struct SymbolModel: Decodable, Identifiable {
    var id: String { name }
    let name: String
    let label: String

    static let allSymbols = Bundle.main.decode([SymbolModel].self, from: "Symbols.json")
    static let example = allSymbols[0]
    static let first = allSymbols[0]
}
