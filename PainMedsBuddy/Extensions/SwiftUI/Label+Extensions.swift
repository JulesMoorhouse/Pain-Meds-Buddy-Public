//
//  Label+Extensions.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

extension Label where Title == Text, Icon == Image {
    init(_ localizedString: Strings, systemImage name: String) {
        self.init(localizedString.rawValue, systemImage: name)
    }
}
