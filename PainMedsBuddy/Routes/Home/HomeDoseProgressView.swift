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

    @ObservedObject var dose: Dose
    @ObservedObject var med: Med

    let gradient = LinearGradient(
        gradient: Gradient(colors:
            [Color.blue, Color.blue]),
        startPoint: .top, endPoint: .top
    )

    var debug = false
    var emptyView = false

    @State var nowDate = Date()
    @State var timer: Timer?

    var disabled: Bool {
        emptyView || !dose.doseShouldHaveElapsed
    }

    var count: Int {
        dose.doseElapsedSeconds
    }

    var total: Int {
        100
    }

    var display: String {
        dose.doseDisplay
    }

    var countDown: String {
        dose.doseShouldHaveElapsed
            ? String(.doseProgressAvailable)
            : dose.doseCountDownSeconds(nowDate: nowDate)
    }

    var progress: CGFloat {
        let onePercent: CGFloat = 1 / CGFloat(dose.doseTotalTimeSeconds)
        let percentage = CGFloat(dose.doseElapsedSeconds) * onePercent
        return 1 - percentage
    }

    var title: String {
        med.medTitle
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
        }
        .background(debug ? Color.yellow : nil)
        .frame(minWidth: 155, minHeight: 215)
    }

    var detail: some View {
        VStack {
            if let med = med {
                MedSymbolView(med: med, font: .headline, width: 25, height: 25)
                    .padding(.horizontal, 5)
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
                .foregroundColor(.primary)
        }
        .padding(.bottom, 70)
    }

    var body: some View {
        ZStack {
            circle
            detail
        }
        .panelled(cornerRadius: 15)
        .onAppear(perform: {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.nowDate = Date()
            }
        })
        .onDisappear(perform: {
            self.timer?.invalidate()
            self.timer = nil
        })
        .disabled(disabled)
        .accessibilityElement(children: .ignore)
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(!disabled ? .isButton : .isStaticText)
        .accessibilityLabel(accessibilityLabel())
        .accessibilityIdentifier(accessibilityIdentifier())
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

    init(dose: Dose, med: Med) {
        self.dose = dose
        self.med = med
    }

    init(disabled: Bool) {
        self.dose = Dose()
        self.med = Med()
        self.emptyView = true
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
