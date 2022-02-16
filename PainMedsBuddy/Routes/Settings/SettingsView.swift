//
//  SettingsView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import AckGenUI
import SwiftUI

struct SettingsView: View {
    static let settingsTag: String? = "Settings"
    static let settingsIcon: String = SFSymbol.gearShapeFill.systemName

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var dataController: DataController
    @EnvironmentObject private var presentableToast: PresentableToastModel

    enum ActiveSheet {
        case advanced, developer, acknowledgements
    }

    @State private var activeSheet: ActiveSheet = .advanced
    @State private var showSheet = false

    var body: some View {
        NavigationViewChild {
            ZStack {
                Form {
                    // --- Advanced ---
                    Section {
                        Button(action: {
                            activeSheet = .advanced
                            showSheet.toggle()
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
                    .frame(maxHeight: 50)

                    // --- Developer ---
                    Section {
                        Button(action: {
                            activeSheet = .developer
                            showSheet.toggle()
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
                    .frame(maxHeight: 50)

                    // --- Acknowledgements ---
                    Section {
                        Button(action: {
                            activeSheet = .acknowledgements
                            showSheet.toggle()
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
                    .frame(maxHeight: 50)

                    // --- support ---
                    Section {
                        SettingsSupportView(dataController: dataController)
                    }
                    .frame(maxHeight: 50)

                    // --- NoResponsibility ---
                    Section(footer:
                        Text(Strings.settingsNoResponsibility)
                            .multilineTextAlignment(.center)
                    ) {}
                        .frame(maxHeight: 200)
                }
                .navigationTitle(Strings.tabTitleSettings.rawValue)
                .navigationBarAccessibilityIdentifier(.tabTitleSettings)
                .toasted(show: $presentableToast.show, data: $presentableToast.data)
                .sheet(isPresented: $showSheet) {
                    sheetOption()
                }
            }
        }
    }

    func sheetOption() -> some View {
        Group {
            switch activeSheet {
            case .advanced:
                SettingsAdvancedView()
            case .developer:
                SettingsDeveloperView()
            case .acknowledgements:
                NavigationViewChild {
                    AcknowledgementsList()
                        .navigationBarTitle(Strings.settingsAcknowledgements.rawValue, displayMode: .inline)
                        .navigationBarAccessibilityIdentifier(.settingsAcknowledgements)
                        .navigationBarItems(leading:
                            Button(action: {
                                showSheet = false
                            }, label: {
                                Text(.commonClose)
                            })
                        )
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
