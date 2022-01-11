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
    case deleteDenied, deleteConfirmation, durationGapInfo, copied, hiddenTitle
}

struct MedEditView: View, DestinationView {
    var navigationBarTitleConfiguration: NavigationBarTitleConfiguration

    let med: Med
    let add: Bool

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var defaultAmount: String
    @State private var colour: String
    @State private var symbol: String
    @State private var dosage: String
    @State private var duration: String
    @State private var durationGap: String
    @State private var measure: String
    @State private var form: String
    @State private var notes: String
    @State private var remaining: String

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .deleteDenied
    @State private var canDelete = false

    let types = ["mg", "ml", "Tspn"]

    let colorColumns = [
        GridItem(.adaptive(minimum: 44)),
    ]

    var hasRelationship = false

    init(med: Med, add: Bool, hasRelationship: Bool) {
        self.med = med
        self.add = add
        self.hasRelationship = hasRelationship

        let title = String(MedEditView.navigationTitle(add: add))

        navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
            title: title,
            displayMode: .automatic
        )

        _title = State(wrappedValue: med.medTitle)
        _defaultAmount = State(wrappedValue: med.medDefaultAmount)
        _colour = State(wrappedValue: med.medColor)
        _symbol = State(wrappedValue: med.medSymbol)
        _dosage = State(wrappedValue: med.medDosage)
        _duration = State(wrappedValue: med.medDuration)
        _durationGap = State(wrappedValue: med.medDurationGap)
        _measure = State(wrappedValue: med.medMeasure)
        _form = State(wrappedValue: med.medForm)
        _notes = State(wrappedValue: med.medNotes)
        _remaining = State(wrappedValue: med.medRemaining)
    }

    var body: some View {
        Form {
            Section(header: Text(.commonBasicSettings)) {
                basicSettingsFields()
            }

            Section(header: Text(.medEditExampleDosage)) {
                HStack {
                    Spacer()
                    Text(med.medDisplay)
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
                SymbolsView(colour: Color($colour.wrappedValue), selectedSymbol: $symbol.onChange(update))
                    .padding(.vertical)
            }

            Section(header: Text(.medEditNotes)) {
                TextEditor(text: $notes.onChange(update))
                    .frame(minHeight: 50)
            }

            buttonsSection()
        }
        .navigationBarTitle(configuration: navigationBarTitleConfiguration)
        .navigationBarAccessibilityIdentifier(MedEditView.navigationTitle(add: add))
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showAlert) {
            alertOption()
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
        case .durationGapInfo:
            return Alert(title: Text(.medEditInfo),
                         message: Text(.medEditGapInfo),
                         dismissButton: .default(Text(.commonOK)))
        case .copied:
            return Alert(title: Text(.medEditInfo),
                         message: Text(.medEditCopied),
                         dismissButton: .default(Text(.commonOK)))
        case .hiddenTitle:
            return Alert(title: Text(.medEditInfo),
                         message: Text(.medEditHiddenTitle),
                         dismissButton: .default(Text(.commonOK)))
        }
    }

    static func navigationTitle(add: Bool) -> Strings {
        add
            ? Strings.medEditAddMed
            : Strings.medEditEditMed
    }

    func update() {
        // med.dose?.objectWillChange.send()

        update(med: med)
    }

    func update(med: Med) {
        med.title = title
        med.defaultAmount = NSDecimalNumber(string: defaultAmount)
        med.color = colour
        med.symbol = symbol
        med.dosage = NSDecimalNumber(string: dosage)
        med.duration = Int16(duration) ?? MedDefault.duration
        med.durationGap = Int16(durationGap) ?? MedDefault.durationGap
        med.measure = measure
        med.form = form
        med.notes = notes
        med.remaining = Int16(remaining) ?? MedDefault.remaining
    }

    func delete() {
        let count = dataController.anyRelationships(for: [med])

        // INFO: If this med only has 1 relationship and we're
        // using hard delete, then delete this med. Otherwise
        // keep the med for use with other doses.
        if count == 1 || DataController.useHardDelete {
            dataController.delete(med)
        } else {
            update()
            med.hidden = true
        }
        presentationMode.wrappedValue.dismiss()
    }

    func copy() {
        let newMed = Med(context: dataController.container.viewContext)
        update(med: newMed)
        newMed.title = InterpolatedStrings.medEditCopiedSuffix(title: newMed.medTitle)
        dataController.save()
    }

    func colourButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == colour {
                Image(systemName: SFSymbol.checkmarkCircle.systemName)
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            colour = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == colour
                ? [.isButton, .isSelected]
                : [.isButton]
        )
        .accessibilityLabel(LocalizedStringKey(item))
        .accessibility(identifier: item)
    }

    func basicSettingsFields() -> some View {
        Group {
            HStack {
                if hasRelationship {
                    Text($title.wrappedValue)
                        .foregroundColor(.secondary)
                        .accessibilityIdentifier(.medEditTitleLabelAID)

                    Spacer()

                    Button(action: {
                        activeAlert = .hiddenTitle
                        showAlert.toggle()
                    }, label: {
                        Image(systemName: SFSymbol.infoCircle.systemName)
                    })
                } else {
                    TextField(String(.commonEgString,
                                     values: [MedDefault.Sensible.title]),
                              text: $title.onChange(update))
                        .accessibilityIdentifier(.medEditTitleText)
                        .textFieldStyle(SelectAllTextFieldStyle())
                }
            }

            rowFields(label: .medEditDefaultAmount,
                      detailValues: [MedDefault.Sensible.medDefaultAmount()],
                      binding: $defaultAmount.onChange(update),
                      keyboardType: .decimalPad)

            rowFields(label: .commonDosage,
                      detailValues: [MedDefault.Sensible.medDosage()],
                      binding: $dosage.onChange(update),
                      keyboardType: .decimalPad)

            rowFields(label: .medEditDuration,
                      detailValues: [MedDefault.Sensible.medDuration()],
                      binding: $duration.onChange(update))

            rowInfoFields(label: .medEditDurationGap,
                          detailValues: [MedDefault.Sensible.medDurationGap()],
                          binding: $durationGap.onChange(update),
                          alertType: .durationGapInfo,
                          keyboardType: .default)

            Picker(.medEditMeasure, selection: $measure.onChange(update)) {
                ForEach(types, id: \.self) {
                    Text($0)
                        .foregroundColor(.primary)
                }
            }
            .foregroundColor(.secondary)
            .accessibilityIdentifier(.medEditMeasure)

            rowFields(label: .medEditForm,
                      detailValues: [MedDefault.Sensible.form],
                      binding: $form.onChange(update))

            rowFields(label: .medEditRemaining,
                      detailValues: [MedDefault.Sensible.medRemaining()],
                      binding: $remaining.onChange(update),
                      keyboardType: .numberPad)
        }
    }

    func rowInfoFields(label: Strings,
                       detailValues: [String],
                       binding: Binding<String>,
                       alertType: ActiveAlert,
                       keyboardType: UIKeyboardType = .default) -> some View
    {
        HStack {
            Text(label)
                .foregroundColor(.secondary)

            Button(action: {
                activeAlert = alertType
                showAlert.toggle()
            }, label: {
                Image(systemName: SFSymbol.infoCircle.systemName)
            })

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
                   keyboardType: UIKeyboardType = .default) -> some View
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

        }
    }

    func buttonsSection() -> some View {
        Group {
            Section {
                Button(Strings.medEditDeleteThisMed.rawValue) {
                    canDelete = hasRelationship == false
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
                    copy()
                    showAlert.toggle()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityIdentifier(.medEditCopyThisMed)
            }
        }
    }
}

struct MedEditView_Previews: PreviewProvider {
    static var previews: some View {
        MedEditView(med: Med.example, add: false, hasRelationship: true)
    }
}
