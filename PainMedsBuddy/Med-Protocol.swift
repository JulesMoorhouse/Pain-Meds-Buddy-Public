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
    var medDuration: String { get }
    var medDurationGap: String { get }
    var medForm: String { get }
    var medMeasure: String { get }
    var medNotes: String { get }
    var medLastTakenDate: Date { get }
    var medCreationDate: Date { get }
    var medRemaining: String { get }
    var medSequence: String { get }
    var medDisplay: String { get }
}
