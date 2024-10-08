//
//  MedEditView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is shown via the MedicationView to allow editing of medication

// swiftlint:disable type_body_length
// swiftlint:disable file_length

import FormValidator
import SwiftUI

struct MedEditView: View {
    @StateObject private var viewModel: ViewModel

    @EnvironmentObject private var dataController: DataController
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var presentableToast: PresentableToastModel

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .deleteConfirmation
    @State private var showPopup = false
    @State private var activePopup: ActivePopup = .durationGapInfo
    @State private var isSaveDisabled = false
    @State private var advancedSectionHidden: Bool = true
    @State private var navigationButtonId = UUID()

    enum ActiveAlert {
        case deleteConfirmation,
             deleteHistoryConfirmation
    }

    enum ActivePopup {
        case durationGapInfo,
             durationPicker,
             durationGapPicker,
             lockedTitle,
             lockedDuration,
             lockedDurationGap
    }

    let types: [String]

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
                        .accessibilityLabel(.commonCancel)
                        .accessibilityIdentifier(.commonCancel)
                })
            }
            .id(self.navigationButtonId) // NOTE: Force new instance creation
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
                    Text(viewModel.add ? .commonAdd : .commonSave)
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityLabel(.commonSave)
                        .accessibilityIdentifier(.commonSave)
                })
            }
            .id(self.navigationButtonId) // NOTE: Force new instance creation
        }
    }

    var body: some View {
        NavigationViewChild {
            ZStack {
                Form {
                    Section(header: Text(.commonBasicSettings)) {
                        basicSettingsFields()
                    }

                    // --- Example ---
                    Section(header: Text(.commonExampleDosage)) {
                        HStack {
                            MedSymbolView(symbol: $viewModel.symbol.wrappedValue,
                                          colour: $viewModel.colour.wrappedValue)

                            Text(viewModel.example)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.secondary)
                        }
                    }

                    // --- Colour Selector ---
                    Section(header: symbolHeader()) {
                        if !$advancedSectionHidden.wrappedValue {
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

                            // --- Notes ---
                            Text(.medEditNotes)
                                .foregroundColor(.secondary)

                            TextArea(
                                Strings.medEditNotesPlaceholder.rawValue,
                                text: $viewModel.notes
                            )
                            .frame(minHeight: 50)
                        }
                    }
                    .animation(.easeInOut(duration: 1))

                    buttonsSection()
                }

                if showPopup == true {
                    popupOption()
                }
            }
            .navigationBarTitle(String(viewModel.navigationTitle(add: viewModel.add)), displayMode: .inline)
            .navigationBarAccessibilityIdentifier(viewModel.navigationTitle(add: viewModel.add))
            .toasted(show: $presentableToast.show, data: $presentableToast.data)
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showAlert) { alertOption() }
            .toolbar {
                backBarButtonItem
                saveBarButtonItem
            }
        }
        .onRotate { _ in
            self.navigationButtonId = UUID()
        }
        .onReceive(viewModel.formValidation.$allValid) { isValid in
            self.isSaveDisabled = !isValid
        }
        .onReceive(viewModel.formValidation.$validationMessages) { messages in print("Validation: \(messages)") }
    }

    // MARK: -

    func popupOption() -> some View {
        VStack {
            switch activePopup {
            case .durationGapInfo:
                InfoPopupView(
                    showing: $showPopup,
                    title: Strings.commonInfo.rawValue,
                    text: Strings.medEditGapInfo.rawValue
                )
                .onAppear { UIApplication.endEditing() }
                .onTapGesture { UIApplication.endEditing() }
            case .lockedTitle, .lockedDuration, .lockedDurationGap:
                InfoPopupView(
                    showing: $showPopup,
                    title: Strings.commonInfo.rawValue,
                    text: Strings.medEditLockedField.rawValue
                )
                .onAppear { UIApplication.endEditing() }
                .onTapGesture { UIApplication.endEditing() }
            case .durationPicker:
                if #available(iOS 15, *) {
                    EmptyView()
                } else {
                    DurationPopupView(
                        title: Strings.medEditDuration.rawValue,
                        showing: $showPopup,
                        duration: $viewModel.durationDate,
                        hourAid: .medEditDurationPickerHourAID,
                        minuteAid: .medEditDurationPickerMinuteAID
                    )
                    .onAppear { UIApplication.endEditing() }
                    .onTapGesture { UIApplication.endEditing() }
                }
            case .durationGapPicker:
                if #available(iOS 15, *) {
                    EmptyView()
                } else {
                    DurationPopupView(
                        title: Strings.medEditDurationGap.rawValue,
                        showing: $showPopup,
                        duration: $viewModel.durationGapDate,
                        hourAid: .medEditDurationGapPickerHourAID,
                        minuteAid: .medEditDurationGapPickerMinuteAID
                    )
                    .onAppear { UIApplication.endEditing() }
                    .onTapGesture { UIApplication.endEditing() }
                }
            }
        }
    }

    func alertOption() -> Alert {
        switch activeAlert {
        case .deleteConfirmation:
            return Alert(
                title: Text(.medEditDeleteMed),
                message: Text(.medEditDeleteAreYouSure),
                primaryButton: .default(
                    Text(.commonDelete),
                    action: delete
                ),
                secondaryButton: .cancel()
            )
        case .deleteHistoryConfirmation:
            return Alert(
                title: Text(.medEditDeleteMedDoseHistory),
                message: Text(.medEditDeleteHistoryAreYouSure),
                primaryButton: .default(
                    Text(.commonDelete),
                    action: deleteDoseHistory
                ),
                secondaryButton: .cancel()
            )
        }
    }

    func delete() {
        viewModel.deleteMed()
        presentationMode.wrappedValue.dismiss()
    }

    func deleteDoseHistory() {
        viewModel.deleteMedDoseHistory()
        presentationMode.wrappedValue.dismiss()
    }

    func symbolHeader() -> some View {
        HStack {
            Text(.medEditSymbol)

            Spacer()

            Button(action: {
                advancedSectionHidden.toggle()
            }, label: {
                ChevronView(direction: $advancedSectionHidden.wrappedValue ? .bottom : .up)
            })
            .accessibilityIdentifier(.medEditAdvancedExpandedAID)
        }
    }

    func colourButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == viewModel.colour {
                Image(systemName: SFSymbol.checkmarkSquare.systemName)
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
            // --- Title ---
            HStack {
                if viewModel.hasRelationship {
                    Text($viewModel.title.wrappedValue)
                        .foregroundColor(.secondary)
                        .accessibilityIdentifier(.medEditTitleLabelAID)

                    Spacer()

                    Button(action: {
                        activePopup = .lockedTitle
                        showPopup.toggle()
                    }, label: {
                        Image(systemName: SFSymbol.lockFill.systemName)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                } else {
                    TextField(String(.commonEgString,
                                     values: [MedDefault.Sensible.title]),
                              text: $viewModel.title)
                        .accessibilityIdentifier(.medEditTitleText)
                        .autocapitalization(.words)
                        .textFieldStyle(SelectAllTextFieldStyle())
                        .validation(viewModel.titleValidator)
                }
            }

            // --- Default Amount ---
            rowFields(label: .medEditDefaultAmount,
                      detailValues: [MedDefault.Sensible.medDefaultAmount()],
                      binding: $viewModel.defaultAmount,
                      keyboardType: .decimalPad,
                      rightDetail: viewModel.form,
                      validationContainer: viewModel.defaultAmountValidator)

            // --- Dosage ---
            rowFields(label: .commonDosage,
                      detailValues: [MedDefault.Sensible.medDosage()],
                      binding: $viewModel.dosage,
                      keyboardType: .decimalPad,
                      rightDetail: viewModel.measure,
                      validationContainer: viewModel.dosageValidator)

            // --- Duration ---
            ZStack(alignment: .leading) {
                rowLabelWithButton(
                    label: .medEditDuration,
                    hasButton: viewModel.hasRelationship,
                    buttonIcon: SFSymbol.lockFill.systemName
                ) {
                    activePopup = .lockedDuration
                    showPopup.toggle()
                }

                rowFieldsDate(label: .medEditDuration,
                              binding: $viewModel.durationDate,
                              validationContainer: viewModel.durationDateValidator,
                              hourAid: .medEditDurationPickerHourAID,
                              minuteAid: .medEditDurationPickerMinuteAID,
                              pickerEnabled: !viewModel.hasRelationship) {
                    showPopup = true
                    activePopup = .durationPicker
                }
                .disabled(viewModel.hasRelationship)
            }

            // --- Duration Gap ---
            ZStack(alignment: .leading) {
                rowLabelWithButton(
                    label: .medEditDurationGap,
                    hasButton: true,
                    buttonIcon: viewModel.hasRelationship
                        ? SFSymbol.lockFill.systemName
                        : SFSymbol.infoCircle.systemName
                ) {
                    if viewModel.hasRelationship {
                        activePopup = .lockedDurationGap
                    } else {
                        activePopup = .durationGapInfo
                    }
                    showPopup.toggle()
                }

                rowFieldsDate(label: .medEditDurationGap,
                              binding: $viewModel.durationGapDate,
                              validationContainer: nil,
                              hourAid: .medEditDurationGapPickerHourAID,
                              minuteAid: .medEditDurationGapPickerMinuteAID,
                              pickerEnabled: !viewModel.hasRelationship) {
                    showPopup = true
                    activePopup = .durationGapPicker
                }
                .disabled(viewModel.hasRelationship)
            }

            // --- Measure ---
            Picker(.medEditMeasure, selection: $viewModel.measure) {
                ForEach(types, id: \.self) {
                    Text($0)
                        .foregroundColor(.primary)
                }
            }
            .foregroundColor(.secondary)
            .accessibilityIdentifier(.medEditMeasure)

            // --- Form ---
            rowFields(label: .medEditForm,
                      detailValues: [MedDefault.Sensible.form],
                      binding: $viewModel.form,
                      validationContainer: viewModel.formValidator)

            // --- Remaining ---
            rowFields(label: .medEditRemaining,
                      detailValues: [MedDefault.Sensible.medRemaining()],
                      binding: $viewModel.remaining,
                      keyboardType: .numberPad,
                      rightDetail: viewModel.form,
                      validationContainer: viewModel.remainingValidator)
        }
    }

    func rowLabelWithButton(
        label: Strings,
        hasButton: Bool,
        buttonIcon: String,
        actionButtonClosure: @escaping () -> Void
    ) -> some View {
        HStack {
            Text(label)
                .foregroundColor(Color.clear)

            if hasButton {
                Button(action: {
                    actionButtonClosure()
                }, label: {
                    Image(systemName: buttonIcon)
                })
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }

    func rowFields(
        label: Strings,
        detailValues: [String],
        binding: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        autoCapitalisation _: UITextAutocapitalizationType = .none,
        rightDetail: String? = nil,
        validationContainer: ValidationContainer
    ) -> some View {
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

    // swiftlint:disable:next function_parameter_count
    func rowFieldsDate(
        label: Strings,
        binding: Binding<String>,
        validationContainer: ValidationContainer?,
        hourAid: Strings,
        minuteAid: Strings,
        pickerEnabled: Bool,
        actionButtonClosure: @escaping () -> Void
    ) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)

            Spacer()

            if #available(iOS 15, *) {
                if UIAccessibility.isVoiceOverRunning {
                    HourMinutePickerView(duration: binding,
                                         hourAid: hourAid,
                                         minuteAid: minuteAid)
                        .buttonStyle(BorderlessButtonStyle())
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityIdentifier(label)
                        .disabled(!pickerEnabled)
                } else {
                    HourMinutePickerView(duration: binding,
                                         hourAid: hourAid,
                                         minuteAid: minuteAid)
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(!pickerEnabled)
                }
            } else {
                Button(action: {
                    actionButtonClosure()
                }, label: {
                    Text("\(binding.wrappedValue.secondsToTimeHM)")
                        .buttonStyle(BorderlessButtonStyle())
                        .accessibilityElement()
                        .accessibility(addTraits: .isButton)
                        .accessibilityIdentifier(label)

                })
                .disabled(!pickerEnabled)
            }
        }
        .if(validationContainer != nil) { view in
            view.validation(validationContainer!)
        }
    }

    func buttonsSection() -> some View {
        Group {
            if !viewModel.add {
                // --- Delete Button ---
                Section {
                    Button(Strings.medEditDeleteThisMed.rawValue) {
                        activeAlert = .deleteConfirmation
                        showAlert.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accentColor(.red)
                    .accessibilityIdentifier(.medEditDeleteThisMed)
                }

                // --- Delete History Button ---
                Section {
                    Button(Strings.medEditDeleteMedDoseHistory.rawValue) {
                        activeAlert = .deleteHistoryConfirmation
                        showAlert.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accentColor(.red)
                    .accessibilityIdentifier(.medEditDeleteMedDoseHistory)
                }

                // --- Elapse Button ---
                Section {
                    Button(Strings.medEditCopyThisMed.rawValue) {
                        viewModel.copyMed()
                        presentationMode.wrappedValue.dismiss()
                        self.presentableToast.data
                            = ToastModel(
                                type: .success,
                                message: String(.medEditCopied)
                            )
                        self.presentableToast.show = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .accessibilityIdentifier(.medEditCopyThisMed)
                    .disabled(isSaveDisabled || viewModel.dataChanged)
                }
            }
        }
    }

    init(dataController: DataController,
         med: Med?,
         add: Bool,
         hasRelationship: Bool)
    {
        let viewModel = ViewModel(
            dataController: dataController,
            med: med,
            add: add,
            hasRelationship: hasRelationship
        )

        _viewModel = StateObject(wrappedValue: viewModel)

        let tempTypes = String(.medEditTypes)
        types = tempTypes.components(separatedBy: ",")
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
