//
//  SplitView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

// swiftlint:disable inclusive_language

import SwiftUI

struct SplitView<Master: View, Detail: View>: View {
    var master: Master
    var detail: Detail

    init(@ViewBuilder master: () -> Master, @ViewBuilder detail: () -> Detail) {
        self.master = master()
        self.detail = detail()
    }

    var body: some View {
        let viewControllers = [UIHostingController(rootView: master), UIHostingController(rootView: detail)]
        return SplitViewController(viewControllers: viewControllers)
    }
}
