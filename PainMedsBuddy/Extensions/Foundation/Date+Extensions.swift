//
//  Date+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Date {
    static var yesterday: Date { Date().dayBefore }
    static var tomorrow: Date { Date().dayAfter }

    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }

    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }

    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var isLastDayOfMonth: Bool {
        dayAfter.month != month
    }
}
