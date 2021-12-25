//
//  HomeView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view shows a summary on medication which has or can be taken next

import CircularProgress
import CoreData
import SwiftUI

struct HomeView: View {
    static let HomeTag: String? = "Home"

    @EnvironmentObject var dataController: DataController

    @FetchRequest(entity: Med.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Med.sequence, ascending: true)],
                  predicate: nil)
    var meds: FetchedResults<Med>

    @FetchRequest(entity: Dose.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Dose.takenDate, ascending: true)],
                  predicate: NSPredicate(format: "elapsed == false AND med != nil"))
    var doses: FetchedResults<Dose>

    var columns: [GridItem] {
        [GridItem(.fixed(200))]
    }

    var noData: Bool {
        doses.count == 0 && meds.count == 0
    }

    var currentMedCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: columns) {
                ForEach(doses, id: \.self) { item in
                    DoseProgressView(
                        dose: item,
                        med: item.med ?? dataController.createMedForDose(dose: item),
                        size: 150
                    )
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal, .bottom])
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if noData {
                    PlaceholderView(text: Strings.commonEmptyView.rawValue,
                                    imageString: "pills")
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            if doses.count > 0 {
                                Text(.homeCurrentMeds)
                                    .foregroundColor(.secondary)
                                    .padding(.leading)

                                currentMedCards
                            }

                            VStack(alignment: .leading) {
                                HomeRecentMedsView(doses: doses, meds: meds)
                                HomeLowMedsView(meds: meds)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(!noData ? Color.systemGroupedBackground.ignoresSafeArea() : nil)
            .navigationTitle(Strings.tabTitleHome.rawValue)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
