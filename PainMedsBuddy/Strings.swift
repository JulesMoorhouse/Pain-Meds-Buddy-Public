//
//  Strings.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

enum Strings: LocalizedStringKey {
    case commonBasicSettings
    case commonDelete
    case commonDosage
    case commonEgString
    case commonEgNum
    case commonEmptyView
    case commonOK
    case commonNoDate
    case commonNotTakenYet
    case commonPleaseSelect
    case commonPleaseAdd
    case commonSort

    case tabTitleHistory
    case tabTitleHome
    case tabTitleInProgress
    case tabTitleMedication
    case tabTitleSettings
    
    case homeCurrentMeds
    case homeMedsRunningOut
    case homeRecentlyTaken
    case homeTakeNext
    case homeTakeNow
    case homeAccessibilityIconRemaining
    case homeAccessibilityIconTaken
    case homeAccessibilityIconTakeNow
    case homeAccessibilityAvailable
    
    case doseProgressAvailable
    case doseProgressUnknownMedication
    case doseProgressAccessibilityAvailable
    case doseProgressAccessibilityRemaining
    
    case selectMedSelectMed
    
    case doseEditAddDose
    case doseEditAreYouSure
    case doseEditAmount
    case doseEditDateTime
    case doseEditDeleteDose
    case doseEditDeleteThisDose
    case doseEditEditDose
    
    case sortOptimized
    case sortCreatedDate
    case sortSortOrder
    case sortTitle
    
    case medsMedications
    case medsSorryUsed
    case medsPleaseSelect
    
    case medEditGapInfo
    case medEditAddMed
    case medEditAreYouSure
    case medEditColour
    case medEditDefaultAmount
    case medEditDefaultText
    case medEditDeleteMed
    case medEditDeleteThisMed
    case medEditDurationGap
    case medEditDuration
    case medEditEditMed
    case medEditExampleDosage
    case medEditForm
    case medEditImage
    case medEditInfo
    case medEditMeasure
    case medEditMg
    case medEditNewMedication
    case medEditNotes
    case medEditPill
    case medEditRemaining
    case medEditSequence
    case medEditSorry
    case medEditSymbol
    
    case settingsAcknowledgements
    case settingsAddExampleData
    case settingsDeleteAllData
}

// https://gist.github.com/Jeehut/c8c9a8caf8dc7c02583a4a07dfbb37aa

extension LocalizedStringKey {
    var stringKey: String {
        let description = "\(self)"

        let components = description.components(separatedBy: "key: \"")
            .map { $0.components(separatedBy: "\",") }
        
        return components[1][0]
    }
}
    
extension Text {
    init(_ localizedString: Strings) {
        self.init(localizedString.rawValue)
    }
    
    init(_ localizedString: Strings, values: [String]) {
        let output = String(format: NSLocalizedString(
                                localizedString.rawValue.stringKey,
                                comment: ""), arguments: values)

        self.init(output)
    }
    
    init(_ localizedString: Strings, comment: StaticString) {
        self.init(
            localizedString.rawValue,
            tableName: nil,
            bundle: nil,
            comment: comment)
    }
}

extension Label where Title == Text, Icon == Image {
    init(_ localizedString: Strings, systemImage name: String) {
        self.init(localizedString.rawValue, systemImage: name)
    }
}

extension Button where Label == Text {
    init(_ localizedString: Strings, action: @escaping () -> Void) {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: "")
        
        self.init(output, action: action)
    }
}

extension DatePicker where Label == Text {
    init(
        _ localizedString: Strings,
        selection: Binding<Date>,
        displayedComponents: DatePicker<Label>.Components = [.hourAndMinute, .date]
    ) {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: "")
        
        self.init(output, selection: selection, displayedComponents: displayedComponents)
    }
}

extension Picker where Label == Text {
    init(_ localizedString: Strings, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: "")
        
        self.init(output, selection: selection, content: content)
    }
}

extension View {
    func navigationTitle(_ localizedString: Strings) -> some View {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: "")
        
        return self.navigationBarTitle(output)
    }
}

extension View {
    func accessibilityLabel(_ localizedString: Strings) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
               
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: "")
        
        return self.accessibilityLabel(output)
    }

    func accessibilityLabel(_ localizedString: Strings, values: [String]) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
               
        let output = String(format: NSLocalizedString(
                                localizedString.rawValue.stringKey,
                                comment: ""),
                            arguments: values)
        
        return self.accessibilityLabel(output)
    }
}

extension String {
    init(_ localizedString: Strings, values: [String]) {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: "")
        
        self.init(format: output, arguments: values)
    }

    init(_ localizedString: Strings) {
        let output = NSLocalizedString(
            localizedString.rawValue.stringKey,
            comment: "")

        self.init(format: output)
    }
}
