//
//  Int-Helper.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Int {
    var secondsToTime: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        let str = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        return str
    }
}
