//
//  DataController+Static.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension DataController {
    public static let useHardDelete = true
    public static let useAddScreenDefaults = false

    static var isUnitTesting: Bool {
        #if DEBUG
            if ProcessInfo.processInfo.environment["UNITTEST"] == "1" {
                return true
            }
        #endif
        return false
    }

    static var isUITesting: Bool {
        #if DEBUG
            if CommandLine.arguments.contains("enable-ui-testing") {
                return true
            }
        #endif
        return false
    }

    static var isSnapshotUITesting: Bool {
        #if DEBUG
            if CommandLine.arguments.contains("enable-snapshot-ui-testing") {
                return true
            }
        #endif
        return false
    }

    static var shouldWipeData: Bool {
        #if DEBUG
            if CommandLine.arguments.contains("wipe-data") {
                return true
            }
        #endif
        return false
    }
}
