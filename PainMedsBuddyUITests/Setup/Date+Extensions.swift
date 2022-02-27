//
//  Date+Extensions.swift
//  PainMedsBuddyUITests
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Date {
    var dataFileFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}
