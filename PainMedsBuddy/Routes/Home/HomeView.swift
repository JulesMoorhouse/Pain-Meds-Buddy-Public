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

    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var tabBarHandler: TabBarHandler
    @EnvironmentObject private var presentableToast: PresentableToast

    var columns: [GridItem] {
        [GridItem(.fixed(200))]
    }

    var noData: Bool {
        viewModel.doses.isEmpty &&
            viewModel.lowMeds.isEmpty &&
            viewModel.canTakeMeds.isEmpty
    }

    var currentMedCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: columns) {
                ForEach(viewModel.doses, id: \.self) { item in
                    if let med = item.med {
                        DoseProgressView(
                            dose: item,
                            med: med
                        )
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal, .bottom])
            .accessibilityIdentifier(.homeCurrentMeds)
        }
    }

    var body: some View {
        NavigationViewChild {
            Group {
                if noData {
                    PlaceholderView(string: .commonEmptyView,
                                    imageString: SFSymbol.pills.systemName)
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            if !viewModel.doses.isEmpty {
                                Text(.homeCurrentMeds)
                                    .foregroundColor(.secondary)
                                    .padding(.leading)

                                currentMedCards
                            }

                            VStack(alignment: .leading) {
                                HomeRecentMedsView(meds: viewModel.canTakeMeds)
                                HomeLowMedsView(meds: viewModel.lowMeds)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(!noData ? Color.systemGroupedBackground.ignoresSafeArea() : nil)
            .toasted(show: $presentableToast.show, message: $presentableToast.message)
            .navigationTitle(Strings.titleHome.rawValue)
            .navigationBarAccessibilityIdentifier(.titleHome)
        }
        .onAppear(perform: {
            self.tabBarHandler.showTabBar()
        })
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
