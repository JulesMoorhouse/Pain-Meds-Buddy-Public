//
//  ModalHackView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct ModalHackView: UIViewControllerRepresentable {
    var dismissible: () -> Bool = { false }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ModalHackView>) -> UIViewController {
        MbModalViewController(dismissible: dismissible)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

extension ModalHackView {
    private final class MbModalViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
        let dismissible: () -> Bool

        init(dismissible: @escaping () -> Bool) {
            self.dismissible = dismissible
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)

            setup()
        }

        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            dismissible()
        }

        // set delegate to the presentation of the root parent
        private func setup() {
            guard let rootPresentationViewController
                = rootParent.presentationController,
                rootPresentationViewController.delegate == nil else { return }
            rootPresentationViewController.delegate = self
        }
    }
}
