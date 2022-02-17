//
//  EnvironmentValues+Extension.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

extension EnvironmentValues {
    var splitViewPreferredDisplayMode: UISplitViewController.DisplayMode {
        get { self[PreferredDisplayModeKey.self] }
        set { self[PreferredDisplayModeKey.self] = newValue }
    }
}

struct PreferredDisplayModeKey: EnvironmentKey {
    static var defaultValue: UISplitViewController.DisplayMode = .automatic
}
