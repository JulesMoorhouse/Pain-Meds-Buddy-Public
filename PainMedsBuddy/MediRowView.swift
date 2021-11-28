//
//  MedsRowView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct MedsRowView: View {
    @ObservedObject var med: Med

    var body: some View {
        NavigationLink(destination: EditMedsView(med: med)) {
            Text(med.medDefaultTitle)
        }
    }
}

struct MedsRowView_Previews: PreviewProvider {
    static var previews: some View {
        MedsRowView(med: Med.example)
    }
}
