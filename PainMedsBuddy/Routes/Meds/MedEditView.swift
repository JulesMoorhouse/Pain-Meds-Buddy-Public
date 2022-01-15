//
//  MedEditView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view is shown via the MedicationView to allow editing of medication

import SwiftUI
import XNavigation

enum ActiveAlert {
    case deleteDenied, deleteConfirmation, copied
}

enum ActivePopup {
    case durationGapInfo, hiddenTitle
}

struct MedEditView: View, DestinationView {
    var navigationBarTitleConfiguration: NavigationBarTitleConfiguration

    @StateObject var viewModel: ViewModel

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .deleteDenied
    @State private var showPopup = false
    @State private var activePopup: ActivePopup = .durationGapInfo
    @State private var canDelete = false

    let types = ["mg", "ml", "Tspn"]

    let colorColumns = [
        GridItem(.adaptive(minimum: 44)),
    ]

    var body: some View {
        ZStack {
            Form {
                Section(header: Text(.commonBasicSettings)) {
                    basicSettingsFields()
                }

                Section(header: Text(.medEditExampleDosage)) {
                    HStack {
                        Spacer()
                        Text(viewModel.med.medDisplay)
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
                        selectedSymbol: $viewModel.symbol.onChange(viewModel.update)
                    )
                    .padding(.vertical)
                }

                Section(header: Text(.medEditNotes)) {
                    TextEditor(text: $viewModel.notes.onChange(viewModel.update))
                        .frame(minHeight: 50)
                }

                buttonsSection()
            }
            .navigationBarTitle(configuration: navigationBarTitleConfiguration)
            .navigationBarAccessibilityIdentifier(viewModel.navigationTitle(add: viewModel.add))
            .onDisappear(perform: dataController.save)
            .alert(isPresented: $showAlert) {
                alertOption()
            }

            if showPopup == true {
                popupOption()
            }
        }
    }

    func popupOption() -> some View {
        switch activePopup {
        case .durationGapInfo:
            return InfoPopupView(showing: $showPopup, text: Strings.medEditGapInfo.rawValue)
        case .hiddenTitle:
            return InfoPopupView(showing: $showPopup, text: Strings.medEditHiddenTitle.rawValue)
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
            viewModel.update()
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
                              text: $viewModel.title.onChange(viewModel.update))
                        .accessibilityIdentifier(.medEditTitleText)
                        .textFieldStyle(SelectAllTextFieldStyle())
                }
            }

            rowFields(label: .medEditDefaultAmount,
                      detailValues: [MedDefault.Sensible.medDefaultAmount()],
                      binding: $viewModel.defaultAmount.onChange(viewModel.update),
                      keyboardType: .decimalPad,
                      rightDetail: viewModel.form)

            rowFields(label: .commonDosage,
                      detailValues: [MedDefault.Sensible.medDosage()],
                      binding: $viewModel.dosage.onChange(viewModel.update),
                      keyboardType: .decimalPad,
                      rightDetail: viewModel.measure)

            rowFieldsDate(
                label: .medEditDuration,
                binding: $viewModel.durationDate.onChange(viewModel.update)
            )

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
                .frame(width: .infinity)

                rowFieldsDate(label: .medEditDurationGap,
                              binding: $viewModel.durationGapDate.onChange(viewModel.update))
            }

            Picker(.medEditMeasure, selection: $viewModel.measure.onChange(viewModel.update)) {
                ForEach(types, id: \.self) {
                    Text($0)
                        .foregroundColor(.primary)
                }
            }
            .foregroundColor(.secondary)
            .accessibilityIdentifier(.medEditMeasure)

            rowFields(label: .medEditForm,
                      detailValues: [MedDefault.Sensible.form],
                      binding: $viewModel.form.onChange(viewModel.update))

            rowFields(label: .medEditRemaining,
                      detailValues: [MedDefault.Sensible.medRemaining()],
                      binding: $viewModel.remaining.onChange(viewModel.update),
                      keyboardType: .numberPad,
                      rightDetail: viewModel.form)
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
                   rightDetail: String? = nil) -> some View
    {
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
    }

    func rowFieldsDate(label: Strings,
                       binding: Binding<Date>) -> some View
    {
        HStack {
            DatePicker(
                label,
                selection: binding,
                displayedComponents: [.hourAndMinute]
            )
            .foregroundColor(.secondary)
            .accessibilityIdentifier(label)
        }
    }

    func buttonsSection() -> some View {
        Group {
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
            }
        }
    }

    init(dataController: DataController, med: Med, add: Bool, hasRelationship: Bool) {
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
