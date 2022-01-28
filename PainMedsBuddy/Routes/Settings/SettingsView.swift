//
//  SettingsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AckGenUI
import SwiftUI
import XNavigation

struct SettingsView: View {
    static let settingsTag: String? = "Settings"
    static let settingsIcon: String = SFSymbol.gearShapeFill.systemName

    @EnvironmentObject private var navigation: Navigation
    @EnvironmentObject private var tabBarHandler: TabBarHandler
    @EnvironmentObject private var presentableToast: PresentableToast

    var body: some View {
        NavigationViewChild {
            ZStack {
                Form {
                    Section {
                        Button(action: {
                            navigation.pushView(
                                SettingsAdvancedView(),
                                animated: true)

                        }, label: {
                            HStack {
                                Text(.settingsAdvanced)
                                    .foregroundColor(Color.primary)

                                Spacer()

                                ChevronView()
                            }
                            .accessibilityElement()
                            .accessibility(addTraits: .isButton)
                            .accessibilityIdentifier(.settingsAdvanced)
                        })
                    }

                    Section {
                        Button(action: {
                            navigation.pushView(
                                SettingsDeveloperView(),
                                animated: true)

                        }, label: {
                            HStack {
                                Text(.settingsDeveloper)
                                    .foregroundColor(Color.primary)

                                Spacer()

                                ChevronView()
                            }
                            .accessibilityElement()
                            .accessibility(addTraits: .isButton)
                            .accessibilityIdentifier(.settingsDeveloper)
                        })
                    }

                    Section {
                        Button(action: {
                            navigation.pushView(
                                AcknowledgementsList()
                                    .navigationTitle(Strings.settingsAcknowledgements.rawValue)
                                    .navigationBarAccessibilityIdentifier(.settingsAcknowledgements)
                                    .onAppear {
                                        self.tabBarHandler.hideTabBar()
                                    }
                                    .onDisappear {
                                        self.tabBarHandler.showTabBar()
                                    },
                                animated: true)

                        }, label: {
                            HStack {
                                Text(.settingsAcknowledgements)
                                    .foregroundColor(Color.primary)

                                Spacer()

                                ChevronView()
                            }
                            .accessibilityElement()
                            .accessibility(addTraits: .isButton)
                            .accessibilityIdentifier(.settingsAcknowledgements)
                        })
                    }

                    Section(footer:
                        Text(Strings.settingsNoResponsibility)
                            .multilineTextAlignment(.center)
                    ) {}
                }
                .navigationTitle(Strings.tabTitleSettings.rawValue)
                .navigationBarAccessibilityIdentifier(.tabTitleSettings)
                .toasted(show: $presentableToast.show, message: $presentableToast.message)
            }
        }
        .onAppear(perform: {
            self.tabBarHandler.showTabBar()
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
