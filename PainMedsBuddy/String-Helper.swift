//
//  String-Helper.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension String {
    // HH:mm:ss
    var timeToSeconds: Int {
        let components: Array = self.components(separatedBy: ":")
        let hours = Int(components[0]) ?? 0
        let minutes = Int(components[1]) ?? 0
        let seconds = Int(components[2]) ?? 0
        let int = (hours * 3600) + (minutes * 60) + seconds
        return int
    }
}
