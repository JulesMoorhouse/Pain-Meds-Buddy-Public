//
//  DoseProgressView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CircularProgress
import SwiftUI

struct DoseProgressView: View {
    @ObservedObject var dose: Dose
    @ObservedObject var med: Med

    let size: CGFloat

    let gradient = LinearGradient(
        gradient: Gradient(colors:
            [Color.blue, Color.blue]),
        startPoint: .top, endPoint: .top)

    var debug = false

    @State var nowDate = Date()
    @State var timer: Timer?

    var countDown: String {
        if dose.elapsed == false {
            if let date = dose.doseElapsedDate {
                return Int(date.timeIntervalSince(nowDate)).secondsToTime
            }
        }
        return "0"
    }

    var doseElapsedInt: Int {
        if dose.elapsed == false {
            return Int(nowDate.timeIntervalSince(dose.doseTakenDate))
        }
        return 0
    }

    var done: Bool {
        dose.doseTotalTime > doseElapsedInt
    }

    var progress: CGFloat {
        CGFloat(doseElapsedInt) / CGFloat(dose.doseTotalTime)
    }

    var body: some View {
        NavigationLink(destination:
            DoseAddView(med: med),
            label: {
                ZStack {
                    VStack(alignment: .center) {
                        CircularProgressView(
                            count: doseElapsedInt,
                            total: dose.doseTotalTime,
                            progress: progress,
                            fill: gradient,
                            lineWidth: 5.0,
                            showText: false)
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

                    VStack {
                        if let med = med {
                            MedSymbolView(med: med, font: .headline, width: 25, height: 25)
                                .padding(.horizontal, 5)
                        }

                        ButtonBorderView(text: "Take Next", width: 100)

                        Text(done ? countDown : "Available")
                            .foregroundColor(.primary)
                    }
                    .padding(.bottom, 70)
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
            })
            .disabled(done)
            .accessibilityElement(children: .ignore)
            .accessibilityRemoveTraits(.isButton)
            .accessibilityAddTraits(done ? .isStaticText : .isButton)
            .accessibilityLabel(
                done
                    ? String(.doseProgressAccessibilityRemaining, values: [med.medTitle, dose.doseDisplay, countDown])
                    : String(.doseProgressAccessibilityAvailable, values: [med.medTitle, dose.doseDisplay])
            )
    }
}

struct DoseProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DoseProgressView(dose: Dose.example, med: Med.example, size: 150)
    }
}
