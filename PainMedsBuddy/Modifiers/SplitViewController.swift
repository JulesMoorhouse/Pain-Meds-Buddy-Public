//
//  SplitViewController.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct SplitViewController: UIViewControllerRepresentable {
    var viewControllers: [UIViewController]
    @Environment(\.splitViewPreferredDisplayMode) var preferredDisplayMode: UISplitViewController.DisplayMode

    func makeUIViewController(context: Context) -> UISplitViewController {
        return UISplitViewController()
    }

    func updateUIViewController(_ splitController: UISplitViewController, context: Context) {
        splitController.preferredDisplayMode = preferredDisplayMode
        splitController.viewControllers = viewControllers
    }
}
