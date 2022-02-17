//
//  TabbedSplitView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct TabbedSidebar: View {
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass
    @State private var selection: String?
    private let views: [TitledView]

    var isLargeiPhone: Bool {
        widthSizeClass == .regular && heightSizeClass == .compact
    }

    var useTabBar: Bool {
        widthSizeClass == .compact || isLargeiPhone
    }

    var body: some View {
        if useTabBar {
            NavigationViewParent {
                TabView(selection: $selection) {
                    ForEach(views, id: \.id) { item in
                        // VStack {
                        // Text("ws=\(widthSizeClass.debugDescription)")
                        // Text("hs=\(heightSizeClass.debugDescription)")
                        item.view
                            // }
                            .tag(item.title)
                            .tabItem {
                                Text(item.title)
                                    .accessibilityIdentifier(item.automationId)
                                item.icon
                            }
                    }
                }
            }
        } else {
            NavigationViewParent {
                SplitView(master: {
                    List(selection: $selection) {
                        ForEach(views, id: \.id) { item in
                            Button(action: {
                                selection = item.tag
                            }, label: {
                                Label {
                                    Text(item.title)
                                } icon: {
                                    item.icon
                                }
                            })
                            .accessibilityIdentifier(item.automationId)
                        }
                    }
                    .accessibilityIdentifier(.sideBarAID)
                    .listStyle(SidebarListStyle())
                }, detail: {
                    // Text("Detail view")
                    // Text("ws=\(widthSizeClass.debugDescription)")
                    // Text("hs=\(heightSizeClass.debugDescription)")
                    if let str = $selection.wrappedValue {
                        let id = Int(str) ?? 0
                        views[id].view
                    }
                })
                .splitViewPreferredDisplayMode(UISplitViewController.DisplayMode.oneBesideSecondary)
                .ignoresSafeArea()
            }
        }
    }

    init(content: [TitledView]) {
        views = content
        _selection = State(wrappedValue: content[0].title)
    }
}
