//
//  DoseProgressView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import CircularProgress
import SwiftUI

struct DoseProgressView<Content: View>: View {
    var item: DoseProgressItem

    @ViewBuilder var buttonDestination: Content

    let gradient = LinearGradient(
        gradient: Gradient(colors:
            [Color.blue, Color.blue]),
        startPoint: .top, endPoint: .top)

    var debug = false
    
    var countDown: String {
        item.remaining.secondsToTime
    }
    
    var done: Bool {
        (item.total > item.elapsed)
    }
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center) {
                CircularProgressView(
                    count: item.elapsed,
                    total: item.total,
                    progress: item.progress,
                    fill: gradient,
                    lineWidth: 5.0,
                    showText: false)
                    .frame(width: item.size - 20, height: item.size - 20)
                    .padding(.top, 10)

                Text(item.labelMed)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(height: 40)
                    .background(debug ? Color.red : nil)
                
                Text(item.labelDose)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .background(debug ? Color.red : nil)
                    .padding(.bottom, 10)
            }
            .background(debug ? Color.yellow : nil)
            .frame(minWidth: item.size, minHeight: item.size)
            
            VStack {
                NavigationLink(destination: self.buttonDestination) {
                    ButtonBorderView(text: "Take Next", width: 100)
                        .disabled(done)
                }
                Text(done ? countDown : "Available")
            }
            .padding(.bottom, 30)
        }
        .panelled(cornerRadius: 15)
    }
}

struct DoseProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DoseProgressView(item: DoseProgressItem.example) {
            EmptyView()
        }
    }
}
