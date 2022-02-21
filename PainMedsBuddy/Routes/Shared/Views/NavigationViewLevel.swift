//
//  NavigationViewLevel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import DeviceKit
import SwiftUI

struct NavigationViewParent<Content: View>: View {
    @ViewBuilder var content: Content

    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass

    var systemVersion = UIDevice.current.systemVersion

    var isLargeIPhone: Bool {
        widthSizeClass == .regular && heightSizeClass == .compact
    }

    var isIOS14: Bool {
        systemVersion.starts(with: "14")
    }

    var body: some View {
        if isLargeIPhone {
            NavigationView {
                content
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        } else if isIOS14 {
            NavigationView {
                content
            }
            .navigationBarHidden(true)
            .iPadOnlyStackNavigationView()
        } else {
            VStack {
                content
            }
        }
    }
}

struct NavigationViewChild<Content: View>: View {
    @ViewBuilder var content: Content

    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass

    var systemVersion = UIDevice.current.systemVersion

    var isLargeIPhone: Bool {
        widthSizeClass == .regular && heightSizeClass == .compact
    }

    var isIOS14: Bool {
        systemVersion.starts(with: "14")
    }

    // NOTE: Check for iOS 15 bug in Pro Max phones which
    // causes incorrect size class and different view
    // below, which causes sheets to dismiss when rotated
    var isIOS15ProMaxDevice: Bool {
        let device = Device.current
        return !isIOS14
            && device.isPhone
            && device.description.contains("Pro Max")
    }

    var body: some View {
        if isIOS15ProMaxDevice || isLargeIPhone {
            NavigationView {
                content
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        } else if isIOS14 {
            NavigationView {
                content
            }
            .navigationBarHidden(true)
            .iPadOnlyStackNavigationView()
        } else {
            NavigationView {
                content
            }
            .navigationBarHidden(true)
            .iPadOnlyStackNavigationView()
        }
    }
}
