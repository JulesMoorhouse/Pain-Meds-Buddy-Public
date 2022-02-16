//
//  HomeDoseProgressView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CircularProgress
import SwiftUI

struct HomeDoseProgressView: View {
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

    enum ActiveSheet {
        case add, edit
    }

    @State private var activeSheet: ActiveSheet = .add
    @State private var showSheet = false
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
        if showEmptyView || dose.elapsed {
            return 0
        }
        let onePercent: CGFloat = 1 / CGFloat(dose.doseTotalTimeSeconds)
        let percentage = CGFloat(dose.doseElapsedSeconds) * onePercent
        return 1 - percentage
    }

    var title: String {
        !showEmptyView ? med.medTitle : ""
    }

    var doseNotElapsed: Bool {
        if !showEmptyView {
            let doseShouldNotHaveElapsed = !dose.doseShouldHaveElapsed
            let doseNotElapsed = !dose.elapsed
            return showEmptyView || (doseShouldNotHaveElapsed && doseNotElapsed)
        }
        return false
    }

    var showCloseCorner: Bool {
        !showEmptyView && dose.doseElapsed
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
                    .accessibilityHidden(true)

                Text(display)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .background(debug ? Color.red : nil)
                    .padding(.bottom, 10)
                    .accessibilityHidden(true)
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
                    .frame(width: 25, height: 25)
                    .padding(.horizontal, 5)
                    .accessibilityHidden(true)
            } else {
                if let med = med {
                    MedSymbolView(symbol: med.medSymbol,
                                  colour: med.medColor,
                                  font: .headline,
                                  width: 25,
                                  height: 25)
                        .padding(.horizontal, 5)
                        .accessibilityHidden(true)
                }
            }

            Button(action: {
                if !doseNotElapsed {
                    close()
                    activeSheet = .add
                    showSheet.toggle()
                } else {
                    activeSheet = .edit
                    showSheet.toggle()
                }
            }, label: {
                ButtonBorderView(
                    text: showEmptyView || doseNotElapsed
                        ? Strings.homeEditDose.rawValue
                        : Strings.homeTakeNext.rawValue,
                    width: 100
                )
            })
            .sheet(isPresented: $showSheet) {
                switch activeSheet {
                case .add:
                    DoseAddView(med: med)
                case .edit:
                    DoseEditView(dataController: dataController,
                                 dose: dose)
                }
            }
            .disabled(showEmptyView)
            .accessibilityRemoveTraits(.isButton)
            .accessibilityAddTraits(showEmptyView ? .isStaticText : .isButton)
            .accessibilityLabel(accessibilityLabel())
            .accessibilityIdentifier(accessibilityIdentifier())

            Text(countDown)
                .foregroundColor(
                    showEmptyView
                        ? .secondary.opacity(0.2)
                        : .primary)
                .accessibilityHidden(true)
        }
        .padding(.bottom, 70)
        .if(showEmptyView) { view in
            view.accessibilityLabel(String(.doseEditAccessibilityNoCurrentMeds))
        }
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
                .accessibilityLabel(accessibilityCloseButtonLabel())
                .accessibilityIdentifier(.doseProgressAccessibilityCloseButton)
            }
            Spacer()
        }
    }

    var body: some View {
        ZStack {
            circle
                .disabled(doseNotElapsed)

            detail
            // .disabled(doseNotElapsed)

            if showCloseCorner {
                cornerClose
            }

            /* --- Debugging ---
              VStack {
                  Text("showEmptyView=\(String(showEmptyView))")
                  Text("elapsed=\(String(dose.elapsed))")
                  Text("doseShouldHaveElapsed=\(String(dose.doseShouldHaveElapsed))")
                  Text("taken=\(dose.doseTakenDate.dateToShortDateTime)")
                  Text("elapsed=\((dose.doseElapsedDate  ?? Date().date1970).dateToShortDateTime)")
                  Text("soft=\((dose.doseSoftElapsedDate ?? Date().date1970).dateToShortDateTime)")
              }.background(Color.yellow).font(.system(size: 10)).accessibilityHidden(true)
             */
        }
        .panelled(cornerRadius: 15)
        .onAppear(perform: {
            if !showEmptyView {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.nowDate = Date()

                    if dose.elapsed == false, dose.doseShouldHaveElapsed {
                        dose.objectWillChange.send()
                        dose.elapsed = true
                        dataController.save()
                    }
                }
            }
        })
        .onDisappear(perform: {
            if !showEmptyView {
                self.timer?.invalidate()
                self.timer = nil
            }
        })
    }

    func accessibilityLabel() -> String {
        showEmptyView ? "" :
            dose.doseShouldHaveElapsed
            ? InterpolatedStrings.doseProgressAccessibilityAvailable(dose: dose, med: med)
            : InterpolatedStrings.doseProgressAccessibilityRemaining(dose: dose, med: med)
    }

    func accessibilityIdentifier() -> Strings {
        showEmptyView ? .nothing :
            dose.doseShouldHaveElapsed
            ? .doseProgressAccessibilityAvailable
            : .doseProgressAccessibilityRemaining
    }

    func accessibilityCloseButtonLabel() -> String {
        showEmptyView ? "" :
            InterpolatedStrings.doseProgressAccessibilityCloseButton(med: med)
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

    init(disabled _: Bool) {
        dose = Dose()
        med = Med()
        showEmptyView = true
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
