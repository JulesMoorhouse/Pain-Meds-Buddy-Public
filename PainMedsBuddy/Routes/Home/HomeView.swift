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
    static let homeTag: String? = "Home"
    static let homeIcon: String = SFSymbol.house.systemName

    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var presentableToast: PresentableToastModel

    var columns: [GridItem] {
        [GridItem(.fixed(200))]
    }

    var noData: Bool {
        viewModel.reaffirmedDoses.isEmpty &&
            viewModel.lowMeds.isEmpty &&
            viewModel.recentMeds.isEmpty
    }

    var currentMedCards: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: columns) {
                if !viewModel.reaffirmedDoses.isEmpty {
                    ForEach(viewModel.reaffirmedDoses, id: \.self) { item in
                        if let med = item.med {
                            HomeDoseProgressView(
                                dose: item,
                                med: med
                            )
                        }
                    }
                } else {
                    HomeDoseProgressView(disabled: true)
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
                    PlaceholderView(
                        string: .commonEmptyView,
                        imageString: HomeView.homeIcon
                    )
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            HomeHeadingView(.homeCurrentMeds)
                                .padding([.leading, .trailing])

                            currentMedCards

                            VStack(alignment: .leading) {
                                HomeRecentMedsView(meds: viewModel.recentMeds)
                                HomeLowMedsView(meds: viewModel.lowMeds)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(!noData ? Color.systemGroupedBackground.ignoresSafeArea() : nil)
            .toasted(show: $presentableToast.show, data: $presentableToast.data)
            .navigationTitle(Strings.commonAppName.rawValue)
            .navigationBarAccessibilityIdentifier(.commonAppName)
        }
        .onAppear(perform: {
            RequestReview.showReview()
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
