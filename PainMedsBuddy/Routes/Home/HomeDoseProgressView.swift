//
//  HomeDoseProgressView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CircularProgress
import SwiftUI
import XNavigation

struct HomeDoseProgressView: View {
    @EnvironmentObject var navigation: Navigation
    @EnvironmentObject private var dataController: DataController

    @ObservedObject var dose: Dose
    @ObservedObject var med: Med

    let gradient = LinearGradient(
        gradient: Gradient(colors:
            [Color.blue, Color.blue]),
        startPoint: .top, endPoint: .top
    )

    var debug = false
    var showEmptyView = false

    @State var nowDate = Date()
    @State var timer: Timer?

    var count: Int {
        !showEmptyView ? dose.doseElapsedSeconds : 0
    }

    var total: Int {
        !showEmptyView ? 100 : 0
    }

    var display: String {
        !showEmptyView ? dose.doseDisplay : ""
    }

    var countDown: String {
        showEmptyView ? "00:00:00" :
            (dose.doseElapsed || dose.doseShouldHaveElapsed)
            ? String(.doseProgressAvailable)
            : dose.doseCountDownSeconds(nowDate: nowDate)
    }

    var progress: CGFloat {
        if showEmptyView {
            return 0
        }
        let onePercent: CGFloat = 1 / CGFloat(dose.doseTotalTimeSeconds)
        let percentage = CGFloat(dose.doseElapsedSeconds) * onePercent
        return 1 - percentage
    }

    var title: String {
        !showEmptyView ? med.medTitle : ""
    }

    var disabled: Bool {
        showEmptyView || (!dose.doseShouldHaveElapsed && !dose.elapsed)
    }
    
    var circle: some View {
        VStack(alignment: .center) {
            CircularProgressView(
                count: count,
                total: total,
                progress: progress,
                fill: gradient,
                lineWidth: 5.0,
                showText: false
            )
            .frame(width: 140, height: 130)
            .padding(.top, 10)
            .background(debug ? Color.red : nil)

            if !showEmptyView {
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
                    .background(debug ? Color.red : nil)
                    .foregroundColor(.primary)

                Text(display)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .background(debug ? Color.red : nil)
                    .padding(.bottom, 10)
            } else {
                DisabledBarView()
                    .padding(.horizontal, 30)
                    .padding(.bottom, 5)
                    .padding(.top, 15)

                DisabledBarView()
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
            }
        }
        .background(debug ? Color.yellow : nil)
        .frame(minWidth: 155, minHeight: 215)
    }

    var detail: some View {
        VStack {
            if showEmptyView {
                Image(systemName: SFSymbol.squareDashed.systemName)
                    .foregroundColor(.semiDisabledBackground)
            } else {
                if let med = med {
                    MedSymbolView(med: med, font: .headline, width: 25, height: 25)
                        .padding(.horizontal, 5)
                }
            }

            Button(action: {
                navigation.pushView(
                    DoseAddView(med: med),
                    animated: true
                )
            }, label: {
                ButtonBorderView(
                    text: Strings.homeTakeNext.rawValue,
                    width: 100
                )
            })

            Text(countDown)
                .foregroundColor(
                    showEmptyView
                        ? .secondary.opacity(0.2)
                        : .primary)
        }
        .padding(.bottom, 70)
    }

    var cornerClose: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()

                Button(
                    action: self.close,
                    label: {
                        Image(systemName: SFSymbol.xMark.systemName)
                            .font(.headline)
                    }
                )
                .padding(8)
            }
            Spacer()

            /* --- Debugging ---
             VStack {
             Text("elapsed=\(String(dose.elapsed))")
                 Text("taken=\(dose.doseTakenDate.dateToShortDateTime)")
                 Text("elapsed=\((dose.doseElapsedDate  ?? Date().date1970).dateToShortDateTime)")
                 Text("soft=\((dose.doseSoftElapsedDate ?? Date().date1970).dateToShortDateTime)")
             }.background(Color.yellow)
              */
        }
    }

    var body: some View {
        ZStack {
            circle
                .disabled(disabled)

            detail
                .disabled(disabled)

            if dose.elapsed {
                cornerClose
            }
        }
        .panelled(cornerRadius: 15)
        .onAppear(perform: {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.nowDate = Date()

                if dose.elapsed == false, dose.doseShouldHaveElapsed {
                    dose.objectWillChange.send()
                    dose.elapsed = true
                    dataController.save()
                }
            }
        })
        .onDisappear(perform: {
            self.timer?.invalidate()
            self.timer = nil
        })
        .accessibilityElement(children: .ignore)
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(showEmptyView || !dose.doseShouldHaveElapsed ? .isStaticText : .isButton)
        .accessibilityLabel(showEmptyView ? "" : accessibilityLabel())
        .accessibilityIdentifier(showEmptyView ? .nothing : accessibilityIdentifier())
    }

    func accessibilityLabel() -> String {
        dose.doseShouldHaveElapsed
            ? InterpolatedStrings.doseProgressAccessibilityAvailable(dose: dose, med: med)
            : InterpolatedStrings.doseProgressAccessibilityRemaining(dose: dose, med: med)
    }

    func accessibilityIdentifier() -> Strings {
        dose.doseShouldHaveElapsed
            ? .doseProgressAccessibilityAvailable
            : .doseProgressAccessibilityRemaining
    }

    func close() {
        dose.objectWillChange.send()
        dose.softElapsedDate = Date()

        dataController.save()
    }

    init(dose: Dose, med: Med) {
        self.dose = dose
        self.med = med
    }

    init(disabled: Bool) {
        self.dose = Dose()
        self.med = Med()
        self.showEmptyView = true
    }
}

struct DoseProgressView_Previews: PreviewProvider {
    static var previews: some View {
        HomeDoseProgressView(
            dose: Dose.example,
            med: Med.example
        )
    }
}
