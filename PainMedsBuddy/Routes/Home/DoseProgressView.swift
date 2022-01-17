//
//  DoseProgressView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CircularProgress
import SwiftUI
import XNavigation

struct DoseProgressView: View {
    @EnvironmentObject var navigation: Navigation

    @ObservedObject var dose: Dose
    @ObservedObject var med: Med

    let size: CGFloat

    let gradient = LinearGradient(
        gradient: Gradient(colors:
            [Color.blue, Color.blue]),
        startPoint: .top, endPoint: .top
    )

    var debug = false

    @State var nowDate = Date()
    @State var timer: Timer?

    var progress: CGFloat {
        CGFloat(dose.doseElapsedSeconds) / CGFloat(dose.doseTotalTimeSeconds)
    }

    var circle: some View {
        VStack(alignment: .center) {
            CircularProgressView(
                count: dose.doseElapsedSeconds,
                total: dose.doseTotalTimeSeconds,
                progress: progress,
                fill: gradient,
                lineWidth: 5.0,
                showText: false
            )
            .frame(width: size - 20, height: size - 20)
            .padding(.top, 10)

            Text(med.medTitle)
                .font(.caption)
                .multilineTextAlignment(.center)
                .frame(height: 40)
                .background(debug ? Color.red : nil)
                .foregroundColor(.primary)

            Text(dose.doseDisplay)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .background(debug ? Color.red : nil)
                .padding(.bottom, 10)
        }
        .background(debug ? Color.yellow : nil)
        .frame(minWidth: size, minHeight: size)
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

            Text(dose.doseShouldHaveElapsed
                ? String(.doseProgressAvailable)
                : dose.doseCountDownSeconds(nowDate: nowDate))
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
        .disabled(!dose.doseShouldHaveElapsed)
        .accessibilityElement(children: .ignore)
        .accessibilityRemoveTraits(.isButton)
        .accessibilityAddTraits(dose.doseShouldHaveElapsed ? .isButton : .isStaticText)
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
}

struct DoseProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DoseProgressView(dose: Dose.example, med: Med.example, size: 150)
    }
}
