//
//  NavigationBarAccessor.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import Foundation
import SwiftUI

struct NavigationBarAccessor: UIViewControllerRepresentable {
    var callback: (UINavigationBar?) -> Void
    private let proxyController = ViewController()

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<NavigationBarAccessor>
    ) -> UIViewController {
        proxyController.callback = callback
        return proxyController
    }

    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<NavigationBarAccessor>
    ) {}

    typealias UIViewControllerType = UIViewController

    private class ViewController: UIViewController {
        var callback: (UINavigationBar?) -> Void = { _ in }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            callback(navigationController?.navigationBar)
        }
    }
}
