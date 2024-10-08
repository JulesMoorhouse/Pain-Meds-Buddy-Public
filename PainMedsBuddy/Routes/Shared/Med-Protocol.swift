//
//  Med-Protocol.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

protocol MedProtocol {
    var medTitle: String { get }
    var medDefaultAmount: String { get }
    var medColor: String { get }
    var medSymbol: String { get }
    var medDosage: String { get }
    var medDurationSeconds: String { get }
    var medDurationGapSeconds: String { get }
    var medFormPlural: String { get }
    var medMeasure: String { get }
    var medNotes: String { get }
    var medLastTakenDate: Date { get }
    var medCreationDate: Date { get }
    var medRemaining: String { get }
    var medDisplay: String { get }
}
