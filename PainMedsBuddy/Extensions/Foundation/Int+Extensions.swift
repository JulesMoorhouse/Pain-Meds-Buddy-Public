//
//  Int+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Int {
    var secondsToTimeHMS: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        let str = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        return str
    }

    var secondsToTimeHM: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let str = String(format: "%02i:%02i", hours, minutes)
        return str
    }

    var secondsToDate: Date {
        let epochTime = TimeInterval(self)
        let date = Date(timeIntervalSince1970: epochTime)
        return date
    }
}
