//
//  Bundle+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension Bundle {
    var shortVersion: String {
        if let result = infoDictionary?["CFBundleShortVersionString"] as? String {
            return result
        } else {
            assertionFailure()
            return ""
        }
    }

    var buildVersion: String {
        if let result = infoDictionary?["CFBundleVersion"] as? String {
            return result
        } else {
            assertionFailure()
            return ""
        }
    }

    var buildDate: String {
        if let result = infoDictionary?["CFBuildDate"] as? String {
            return result
        } else {
            assertionFailure()
            return ""
        }
    }

    var buildNumber: String {
        if let result = infoDictionary?["CFBuildNumber"] as? String {
            return result
        } else {
            assertionFailure()
            return ""
        }
    }

    var fullVersion: String {
        return "\(shortVersion)(\(buildVersion))"
    }
}
