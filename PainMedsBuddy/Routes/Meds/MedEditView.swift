//
//  MedEditView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is shown via the MedicationView to allow editing of medication

// swiftlint:disable type_body_length

import FormValidator
import SwiftUI
import XNavigation

enum ActiveAlert {
    case deleteDenied, deleteConfirmation, copied
}

enum ActivePopup {
    case durationGapInfo, hiddenTitle, durationPicker, durationGapPicker
}

struct MedEditView: View, DestinationView {
    var navigationBarTitleConfiguration: NavigationBarTitleConfiguration

    @StateObject private var viewModel: ViewModel

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var tabBarHandler: TabBarHandler

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .deleteDenied
    @State private var showPopup = false
    @State private var activePopup: ActivePopup = .durationGapInfo
    @State private var canDelete = false
    @State private var isSaveDisabled = false

    let types = ["mg", "ml", "Tspn"]

    let colorColumns = [
        GridItem(.adaptive(minimum: 44)),
    ]

    var backBarButtonItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            HStack {
                Text("")
                    .accessibilityHidden(true)

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text(.commonCancel)
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityIdentifier(.commonCancel)
                })
            }
        }
    }

    var saveBarButtonItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Text("")
                    .accessibilityHidden(true)

                Button(action: {
                    let valid = viewModel.formValidation.triggerValidation()
                    if valid {
                        viewModel.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text(.commonSave)
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityIdentifier(.commonSave)
                })
            }
        }
    }

    var body: some View {
        ZStack {
            Form {
                Section(header: Text(.commonBasicSettings)) {
                    basicSettingsFields()
                }

                Section(header: Text(.medEditExampleDosage)) {
                    HStack {
                        Spacer()
                        Text(viewModel.example)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text(.medEditSymbol)) {
                    Text(.medEditColour)
                        .foregroundColor(.secondary)
                    LazyVGrid(columns: colorColumns) {
                        ForEach(Med.colours, id: \.self, content: colourButton)
                    }
                    .padding(.vertical)

                    Text(.medEditImage)
                        .foregroundColor(.secondary)
                    SymbolsView(
                        colour: Color($viewModel.colour.wrappedValue),
                        selectedSymbol: $viewModel.symbol
                    )
                    .padding(.vertical)
                }

                Section(header: Text(.medEditNotes)) {
                    TextArea(
                        Strings.medEditNotesPlaceholder.rawValue,
                        text: $viewModel.notes
                    )
                    .frame(minHeight: 50)
                }

                buttonsSection()
            }
            .navigationBarTitle(configuration: navigationBarTitleConfiguration)
            .navigationBarAccessibilityIdentifier(viewModel.navigationTitle(add: viewModel.add))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                backBarButtonItem
                saveBarButtonItem
            }
            .onReceive(viewModel.formValidation.$allValid) { isValid in
                self.isSaveDisabled = !isValid
            }
            .onReceive(viewModel.formValidation.$validationMessages) { messages in print("Validation: \(messages)") }
            .alert(isPresented: $showAlert) { alertOption() }
            .onAppear(perform: {
                self.tabBarHandler.hideTabBar()
            })
            .onDisappear(perform: {
                self.tabBarHandler.showTabBar()
            })

            if showPopup == true {
                popupOption()
            }
        }
    }

    func popupOption() -> some View {
        VStack {
            switch activePopup {
            case .durationGapInfo:
                InfoPopupView(
                    showing: $showPopup,
                    text: Strings.medEditGapInfo.rawValue
                )
            case .hiddenTitle:
                InfoPopupView(
                    showing: $showPopup,
                    text: Strings.medEditHiddenTitle.rawValue
                )
            case .durationPicker:
                DurationPopupView(
                    title: Strings.medEditDuration.rawValue,
                    showing: $showPopup,
                    duration: $viewModel.durationDate
                )
                .onAppear { UIApplication.endEditing() }
                .onTapGesture { UIApplication.endEditing() }
            case .durationGapPicker:
                DurationPopupView(
                    title: Strings.medEditDurationGap.rawValue,
                    showing: $showPopup,
                    duration: $viewModel.durationGapDate
                )
                .onAppear { UIApplication.endEditing() }
                .onTapGesture { UIApplication.endEditing() }
            }
        }
    }

    func alertOption() -> Alert {
        switch activeAlert {
        case .deleteConfirmation:
            return Alert(title: Text(.medEditDeleteMed),
                         message: Text(.medEditAreYouSure),
                         primaryButton: .default(Text(.commonDelete), action: delete),
                         secondaryButton: .cancel())
        case .deleteDenied:
            return Alert(title: Text(.medEditDeleteMed),
                         message: Text(.medEditSorry),
                         dismissButton: .default(Text(.commonOK)))
        case .copied:
            return Alert(title: Text(.medEditInfo),
                         message: Text(.medEditCopied),
                         dismissButton: .default(Text(.commonOK)))
        }
    }

    func delete() {
        viewModel.deleteMed()
        presentationMode.wrappedValue.dismiss()
    }

    func colourButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == viewModel.colour {
                Image(systemName: SFSymbol.checkmarkCircle.systemName)
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            viewModel.colour = item
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == viewModel.colour
                ? [.isButton, .isSelected]
                : [.isButton]
        )
        .accessibilityLabel(LocalizedStringKey(item))
        .accessibility(identifier: item)
    }

    func basicSettingsFields() -> some View {
        Group {
            HStack {
                if viewModel.hasRelationship {
                    Text($viewModel.title.wrappedValue)
                        .foregroundColor(.secondary)
                        .accessibilityIdentifier(.medEditTitleLabelAID)

                    Spacer()

                    Button(action: {
                        activePopup = .hiddenTitle
                        showPopup.toggle()
                    }, label: {
                        Image(systemName: SFSymbol.infoCircle.systemName)
                    })
                        .buttonStyle(BorderlessButtonStyle())
                } else {
                    TextField(String(.commonEgString,
                                     values: [MedDefault.Sensible.title]),
                              text: $viewModel.title)
                        .accessibilityIdentifier(.medEditTitleText)
                        .textFieldStyle(SelectAllTextFieldStyle())
                        .validation(viewModel.titleValidator)
                }
            }

            rowFields(label: .medEditDefaultAmount,
                      detailValues: [MedDefault.Sensible.medDefaultAmount()],
                      binding: $viewModel.defaultAmount,
                      keyboardType: .decimalPad,
                      rightDetail: viewModel.form,
                      validationContainer: viewModel.defaultAmountValidator)

            rowFields(label: .commonDosage,
                      detailValues: [MedDefault.Sensible.medDosage()],
                      binding: $viewModel.dosage,
                      keyboardType: .decimalPad,
                      rightDetail: viewModel.measure,
                      validationContainer: viewModel.dosageValidator)

            rowFieldsDate(
                label: .medEditDuration,
                binding: $viewModel.durationDate, validationContainer: viewModel.durationDateValidator
            ) {
                showPopup = true
                activePopup = .durationPicker
            }

            ZStack(alignment: .leading) {
                HStack {
                    Text(.medEditDurationGap)
                        .foregroundColor(Color.clear)

                    Button(action: {
                        activePopup = .durationGapInfo
                        showPopup.toggle()
                    }, label: {
                        Image(systemName: SFSymbol.infoCircle.systemName)
                    })
                        .buttonStyle(BorderlessButtonStyle())
                }

                rowFieldsDate(
                    label: .medEditDurationGap,
                    binding: $viewModel.durationGapDate,
                    validationContainer: nil
                ) {
                    showPopup = true
                    activePopup = .durationGapPicker
                }
            }

            Picker(.medEditMeasure, selection: $viewModel.measure) {
                ForEach(types, id: \.self) {
                    Text($0)
                        .foregroundColor(.primary)
                }
            }
            .foregroundColor(.secondary)
            .accessibilityIdentifier(.medEditMeasure)

            rowFields(label: .medEditForm,
                      detailValues: [MedDefault.Sensible.form],
                      binding: $viewModel.form,
                      validationContainer: viewModel.formValidator)

            rowFields(label: .medEditRemaining,
                      detailValues: [MedDefault.Sensible.medRemaining()],
                      binding: $viewModel.remaining,
                      keyboardType: .numberPad,
                      rightDetail: viewModel.form,
                      validationContainer: viewModel.remainingValidator)
        }
    }

    func rowInfoFields(label: Strings,
                       detailValues: [String],
                       binding: Binding<String>,
                       keyboardType: UIKeyboardType = .default,
                       actionButtonClosure: @escaping () -> Void) -> some View
    {
        HStack {
            Text(label)
                .foregroundColor(.secondary)

            Button(action: {
                actionButtonClosure()
            }, label: {
                Image(systemName: SFSymbol.infoCircle.systemName)
            })
                .buttonStyle(BorderlessButtonStyle())

            Spacer()

            TextField(String(.commonEgString,
                             values: detailValues),
                      text: binding)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
                .accessibilityIdentifier(label)
                .textFieldStyle(SelectAllTextFieldStyle())
        }
    }

    func rowFields(label: Strings,
                   detailValues: [String],
                   binding: Binding<String>,
                   keyboardType: UIKeyboardType = .default,
                   rightDetail: String? = nil,
                   validationContainer: ValidationContainer) -> some View
    {
        HStack {
            HStack {
                Text(label)
                    .foregroundColor(.secondary)

                Spacer()

                TextField(String(.commonEgString,
                                 values: detailValues),
                          text: binding)
                    .keyboardType(keyboardType)
                    .multilineTextAlignment(.trailing)
                    .accessibilityIdentifier(label)
                    .textFieldStyle(SelectAllTextFieldStyle())

                if let rightDetail = rightDetail {
                    Spacer()
                        .frame(width: 5)
                    Text(rightDetail)
                        .foregroundColor(.secondary)
                }
            }
            .validation(validationContainer)
        }
    }

    func rowFieldsDate(label: Strings,
                       binding: Binding<String>,
                       validationContainer: ValidationContainer?,
                       actionButtonClosure: @escaping () -> Void) -> some View
    {
        HStack {
            Text(label)
                .foregroundColor(.secondary)

            Spacer()

            Button(action: {
                actionButtonClosure()
            }, label: {
                Text("\(binding.wrappedValue.secondsToTimeHM)")
                    .buttonStyle(BorderlessButtonStyle())
                    .accessibilityElement()
                    .accessibility(addTraits: .isButton)
                    .accessibilityIdentifier(label)
            })
        }
        .if(validationContainer != nil) { view in
            view.validation(validationContainer!)
        }
    }

    func buttonsSection() -> some View {
        Group {
            if !viewModel.add {
                Section {
                    Button(Strings.medEditDeleteThisMed.rawValue) {
                        canDelete = viewModel.hasRelationship == false
                        activeAlert = canDelete ? .deleteConfirmation : .deleteDenied
                        showAlert.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accentColor(.red)
                    .accessibilityIdentifier(.medEditDeleteThisMed)
                }

                Section {
                    Button(Strings.medEditCopyThisMed.rawValue) {
                        activeAlert = .copied
                        viewModel.copyMed()
                        showAlert.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityIdentifier(.medEditCopyThisMed)
                    .disabled(isSaveDisabled)
                }
            }
        }
    }

    init(dataController: DataController, med: Med?, add: Bool, hasRelationship: Bool) {
        let viewModel = ViewModel(
            dataController: dataController,
            med: med,
            add: add,
            hasRelationship: hasRelationship
        )

        _viewModel = StateObject(wrappedValue: viewModel)

        let title = String(viewModel.navigationTitle(add: add))

        navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
            title: title,
            displayMode: .automatic
        )
    }
}

struct MedEditView_Previews: PreviewProvider {
    static var previews: some View {
        MedEditView(
            dataController: DataController.preview,
            med: Med.example,
            add: false,
            hasRelationship: true
        )
    }
}
