import AckGenUI
import CoreData
import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: TabSide = .home
    @SceneStorage("selectedView2") var selectedView2: String?

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.horizontalSizeClass) var widthSizeClass
    @Environment(\.verticalSizeClass) var heightSizeClass

    enum TabSide: String {
        case home, history, inProgress, medications, settings
    }

    var isLargeiPhone: Bool {
        widthSizeClass == .regular && heightSizeClass == .compact
    }

    var useTabBar: Bool {
        widthSizeClass == .compact || isLargeiPhone
    }

    var body: some View {
        Group {
            if useTabBar {
                NavigationViewParent {
                    TabView(selection: $selectedView) {
                        HomeView(dataController: dataController)
                            .tag(TabSide.home)
                            .tabItem {
                                Image(systemName: HomeView.homeIcon)
                                Text(.tabTitleHome)
                                    .accessibilityIdentifier(.tabTitleHome)
                            }

                        DosesView(dataController: dataController, showElapsedDoses: true)
                            .tag(TabSide.history)
                            .tabItem {
                                Text(.tabTitleHistory)
                                    .accessibilityIdentifier(.tabTitleHistory)
                                Image(systemName: DosesView.historyIcon)
                            }

                        DosesView(dataController: dataController, showElapsedDoses: false)
                            .tag(TabSide.inProgress)
                            .tabItem {
                                Text(.tabTitleInProgress)
                                    .accessibilityIdentifier(.tabTitleInProgress)
                                Image(systemName: DosesView.inProgressIcon)
                            }

                        MedsView(dataController: dataController)
                            .tag(TabSide.medications)
                            .tabItem {
                                Text(.tabTitleMedications)
                                    .accessibilityIdentifier(.tabTitleMedications)
                                Image(systemName: MedsView.medsIcon)
                            }

                        SettingsView()
                            .tag(TabSide.settings)
                            .tabItem {
                                Text(.tabTitleSettings)
                                    .accessibilityIdentifier(.tabTitleSettings)
                                Image(systemName: SettingsView.settingsIcon)
                            }
                    }
                }
            } else {
                NavigationViewParent {
                    SplitView(master: {
                        List {
                            Button(action: {
                                selectedView = TabSide.home
                            }, label: {
                                Label(.tabTitleHome, systemImage: HomeView.homeIcon)
                            })
                            .accessibilityIdentifier(.tabTitleHome)

                            Button(action: {
                                selectedView = TabSide.history
                            }, label: {
                                Label(.tabTitleHistory, systemImage: DosesView.historyIcon)
                            })
                            .accessibilityIdentifier(.tabTitleHistory)

                            Button(action: {
                                selectedView = TabSide.inProgress
                            }, label: {
                                Label(.tabTitleInProgress, systemImage: DosesView.inProgressIcon)
                            })
                            .accessibilityIdentifier(.tabTitleInProgress)

                            Button(action: {
                                selectedView = TabSide.medications
                            }, label: {
                                Label(.tabTitleMedications, systemImage: MedsView.medsIcon)
                            })
                            .accessibilityIdentifier(.tabTitleMedications)

                            Button(action: {
                                selectedView = TabSide.settings
                            }, label: {
                                Label(.tabTitleSettings, systemImage: SettingsView.settingsIcon)
                            })
                            .accessibilityIdentifier(.tabTitleSettings)
                        }
                        .listStyle(SidebarListStyle())
                    }, detail: {
                        // NavigationViewParent {
                        // Text("Detail view")
                        // Text("ws=\(widthSizeClass.debugDescription)")
                        // Text("hs=\(heightSizeClass.debugDescription)")

                            switch $selectedView.wrappedValue  {
                            case .home:
                                HomeView(dataController: dataController)
                            case .history:
                                DosesView(dataController: dataController, showElapsedDoses: true)
                            case .inProgress:
                                DosesView(dataController: dataController, showElapsedDoses: false)
                            case .medications:
                                MedsView(dataController: dataController)
                            case .settings:
                                SettingsView()
                            }
                    })
                    .splitViewPreferredDisplayMode(UISplitViewController.DisplayMode.oneBesideSecondary)
                    .ignoresSafeArea()
                }
            }
        }
    }

//    init() {
//        if selectedView == nil {
//            selectedView = HomeView.homeTag
//        }
//    }
}

 struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
 }
