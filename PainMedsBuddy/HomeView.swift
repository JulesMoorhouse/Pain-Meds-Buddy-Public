//
//  HomeView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//
// INFO: This view shows a summary on medication which has or can be taken next

import CircularProgress
import SwiftUI

struct HomeView: View {
    static let HomeTag: String? = "Home"

    @EnvironmentObject var dataController: DataController

    @State var count = 0
    let size: CGFloat = 150
    let total = 10

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: size, maximum: size))]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(0 ..< 4) { index in

                        DoseProgressView(item: DoseProgressItem(
                            size: size,
                            count: count,
                            total: total,
                            labelMed: (index % 2 == 0) ? "Codeine Phosphate" : "Paracetomol",
                            labelDose: "1 x 300mg Pill"))
                    }
                }
                HStack {
                    Button("Decrease", action: { self.count -= 1 })
                    Spacer()
                    Button("Increase", action: { self.count += 1 })
                }
                .padding(50)
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
}

// Button("Add Data") {
//    dataController.deleteAll()
//    try? dataController.createSampleData()
// }
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
