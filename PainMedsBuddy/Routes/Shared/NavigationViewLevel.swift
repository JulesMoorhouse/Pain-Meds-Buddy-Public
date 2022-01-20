//
//  NavigationViewLevel.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct NavigationViewParent<Content: View>: View {
    @ViewBuilder var content: Content

    var systemVersion = UIDevice.current.systemVersion

    var body: some View {
        if systemVersion.starts(with: "14" ) {
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

    var systemVersion = UIDevice.current.systemVersion

    var body: some View {
        if systemVersion.starts(with: "14" ) {
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
