//
//  DoseProgressView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CircularProgress
import SwiftUI

struct DoseProgressView: View {
    let dose: Dose
    let med: Med
    let size: CGFloat
    
    let gradient = LinearGradient(
        gradient: Gradient(colors:
            [Color.blue, Color.blue]),
        startPoint: .top, endPoint: .top)

    var debug = false

    var countDown: String {
        dose.doseTimeRemainingInt.secondsToTime
    }

    var done: Bool {
        dose.doseTotalTime > dose.doseElapsedInt
    }

    var progress: CGFloat {
        return CGFloat(dose.doseElapsedInt) / CGFloat(dose.doseTotalTime)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                CircularProgressView(
                    count: dose.doseElapsedInt,
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
                NavigationLink(destination: DoseAddView(med: med)) {
                    ButtonBorderView(text: "Take Next", width: 100)
                }
                .disabled(done)
                Text(done ? countDown : "Available")
            }
            .padding(.bottom, 30)
        }
        .panelled(cornerRadius: 15)
    }
}

struct DoseProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DoseProgressView(dose: Dose.example, med: Med.example, size: 150)
    }
}
