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

    @StateObject var viewModel: ViewModel

    var columns: [GridItem] {
        [GridItem(.fixed(200))]
    }

    var noData: Bool {
        viewModel.doses.isEmpty && viewModel.meds.isEmpty
    }

    var currentMedCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: columns) {
                ForEach(viewModel.doses, id: \.self) { item in
                    DoseProgressView(
                        dose: item,
                        med: item.med ?? viewModel.createMedForDose(dose: item),
                        size: 150
                    )
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.horizontal, .bottom])
            .accessibilityIdentifier(.homeCurrentMeds)
        }
    }

    var body: some View {
        NavigationView {
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
                                HomeRecentMedsView(doses: viewModel.doses, meds: viewModel.meds)
                                HomeLowMedsView(meds: viewModel.meds)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(!noData ? Color.systemGroupedBackground.ignoresSafeArea() : nil)
            .navigationTitle(Strings.tabTitleHome.rawValue)
            .navigationBarAccessibilityIdentifier(.tabTitleHome)
        }
        .iPadOnlyStackNavigationView()
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
