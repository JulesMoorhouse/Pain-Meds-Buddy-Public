//
//  String+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation

extension String {
    var timeToSeconds: Int {
        // NOTE: HH:mm:ss
        let components: Array = self.components(separatedBy: ":")
        let hours = Int(components[0]) ?? 0
        let minutes = Int(components[1]) ?? 0
        let seconds = Int(components[2]) ?? 0
        let int = (hours * 3600) + (minutes * 60) + seconds
        return int
    }

    var secondsToTimeHMS: String {
        let hours = (Int(self) ?? 0) / 3600
        let minutes = (Int(self) ?? 0) / 60 % 60
        let seconds = (Int(self) ?? 0) % 60
        let str = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        return str
    }

    var secondsToTimeHM: String {
        let hours = (Int(self) ?? 0) / 3600
        let minutes = (Int(self) ?? 0) / 60 % 60
        let str = String(format: "%02i:%02i", hours, minutes)
        return str
    }

    func check(in string: String, forAnyIn characters: String) -> Bool {
        let customSet = CharacterSet(charactersIn: characters)
        return string.rangeOfCharacter(from: customSet) != nil
    }

    var extractedParameter: String? {
        guard check(in: self, forAnyIn: "[]") == true else {
            return nil
        }
        // NOTE: abc[123]def
        var processing = false
        var output = ""

        for char in self {
            if char == "]" {
                processing = false
            }

            if processing {
                output.append(char)
            }

            if char == "[" {
                processing = true
            }
        }

        return output.isEmpty ? nil : output
    }

    var isNumber: Bool {
        isInt() || isDouble()
    }

    func isInt() -> Bool {
        if Int(self) != nil {
            return true
        }
        return false
    }

    func isDouble() -> Bool {
        if Double(self) != nil {
            return true
        }
        return false
    }

    func doubleOrIntString() -> String {
        let double: Double = self.isDouble() ? Double(self) ?? 0.0 : 0.0
        let int: Int = self.isInt() ? Int(self) ?? 0 : 0

        let output: String =
            self.isDouble()
        ? "\(String(describing: double))"
                : self.isInt() ? "\(String(describing: int))"
                : "0"
        return output
    }

    init(_ localisedString: Strings, values: [String]) {
        let output = NSLocalizedString(
            localisedString.rawValue.stringKey,
            comment: ""
        )

        self.init(format: output, arguments: values)
    }

    init(_ localisedString: Strings) {
        let output = NSLocalizedString(
            localisedString.rawValue.stringKey,
            comment: ""
        )

        self.init(format: output)
    }
}
