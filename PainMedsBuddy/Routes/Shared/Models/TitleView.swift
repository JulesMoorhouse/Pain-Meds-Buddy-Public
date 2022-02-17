//
//  TitleView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct TitledView: Identifiable {
    let id = UUID()
    let tag: String
    let automationId: Strings
    let title: String
    let icon: Image
    let view: AnyView

    init<T: View>(tag: String,
                  automationId: Strings,
                  title: String,
                  systemImage: String,
                  view: T)
    {
        self.tag = tag
        self.automationId = automationId
        self.title = title
        self.icon = Image(systemName: systemImage)
        self.view = AnyView(view)
    }
}
