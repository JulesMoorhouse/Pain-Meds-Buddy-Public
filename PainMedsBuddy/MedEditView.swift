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
    case deleteDenied, deleteConfirmation, durationGapInfo
}

struct MedEditView: View {// DestinationView {
    // var navigationBarTitleConfiguration: NavigationBarTitleConfiguration

    let med: Med
    let add: Bool

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var defaultAmount: String
    @State private var color: String
    @State private var symbol: String
    @State private var dosage: String
    @State private var duration: String
    @State private var durationGap: String
    @State private var measure: String
    @State private var form: String
    @State private var notes: String
    @State private var remaining: String
    @State private var sequence: String

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .deleteDenied
    @State private var canDelete = false

    let types = ["mg", "ml", "Tspn"]

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(med: Med, add: Bool) {
        self.med = med
        self.add = add

//        self.navigationBarTitleConfiguration = NavigationBarTitleConfiguration(
//            title: DoseEditView.navigationTitle(add: add),
//            displayMode: .automatic
//        )

        _title = State(wrappedValue: med.medTitle)
        _defaultAmount = State(wrappedValue: med.medDefaultAmount)
        _color = State(wrappedValue: med.medColor)
        _symbol = State(wrappedValue: med.medSymbol)
        _dosage = State(wrappedValue: med.medDosage)
        _duration = State(wrappedValue: med.medDuration)
        _durationGap = State(wrappedValue: med.medDurationGap)
        _measure = State(wrappedValue: med.medMeasure)
        _form = State(wrappedValue: med.medForm)
        _notes = State(wrappedValue: med.medNotes)
        _remaining = State(wrappedValue: med.medRemaining)
        _sequence = State(wrappedValue: med.medSequence)
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
                    ForEach(Med.colors, id: \.self, content: colourButton)
                }
                .padding(.vertical)

                Text(.medEditImage)
                    .foregroundColor(.secondary)
                SymbolsView(colour: Color($color.wrappedValue), selectedSymbol: $symbol.onChange(update))
                    .padding(.vertical)
            }

            Section(header: Text(.medEditNotes)) {
                TextEditor(text: $notes.onChange(update))
            }

            Section {
                Button(Strings.medEditDeleteThisMed.rawValue) {
                    canDelete = dataController.hasRelationship(for: med) == false
                    activeAlert = canDelete ? .deleteConfirmation : .deleteDenied
                    showAlert.toggle()
                }
                .accentColor(.red)
            }
        }
        // .navigationBarTitle(configuration: navigationBarTitleConfiguration)
        .navigationTitle(MedEditView.navigationTitle(add: add))
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showAlert) {
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
            }
        }
    }

    static func navigationTitle(add: Bool) -> LocalizedStringKey {
        add
            ? Strings.medEditAddMed.rawValue
            : Strings.medEditEditMed.rawValue
    }

    func update() {
        med.dose?.objectWillChange.send()

        med.title = title
        med.defaultAmount = NSDecimalNumber(string: defaultAmount)
        med.color = color
        med.symbol = symbol
        med.dosage = NSDecimalNumber(string: dosage)
        med.duration = Int16(duration) ?? MedDefault.duration
        med.durationGap = Int16(durationGap) ?? MedDefault.durationGap
        med.measure = measure
        med.form = form
        med.notes = notes
        med.remaining = Int16(remaining) ?? MedDefault.remaining
        med.sequence = Int16(sequence) ?? MedDefault.sequence
    }

    func delete() {
        dataController.delete(med)
        presentationMode.wrappedValue.dismiss()
    }

    func colourButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : [.isButton]
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    func basicSettingsFields() -> some View {
        Group {
            TextField(String(.commonEgString,
                             values: [MedDefault.Sensible.title]),
                      text: $title.onChange(update))

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

            rowFields(label: .medEditForm,
                      detailValues: [MedDefault.Sensible.form],
                      binding: $form.onChange(update))

            rowFields(label: .medEditRemaining,
                      detailValues: [MedDefault.Sensible.medRemaining()],
                      binding: $remaining.onChange(update),
                      keyboardType: .numberPad)

            rowFields(label: .medEditSequence,
                      detailValues: [MedDefault.Sensible.medSequence()],
                      binding: $sequence.onChange(update),
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
                Image(systemName: "info.circle")
            })

            Spacer()

            TextField(String(.commonEgString,
                             values: detailValues),
                      text: binding)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
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
        }
    }
}

struct MedEditView_Previews: PreviewProvider {
    static var previews: some View {
        MedEditView(med: Med.example, add: false)
    }
}
