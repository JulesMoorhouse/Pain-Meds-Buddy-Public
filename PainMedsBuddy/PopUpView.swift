//
//  PopUpView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct PopUpView<Content: View, Close: View>: View {
    let text: String
    @ViewBuilder var content: Content
    @ViewBuilder var close: Close

    let width: CGFloat = 240
    
    var body: some View {

        Color.black.opacity(0.2).ignoresSafeArea()
        
        VStack(spacing: 10) {
            ZStack {
                Text(text)
                    .bold()
                close.offset(x: (width/2) - 30)
            }
            
            Spacer()
        
            content
        }
        .padding()
        .frame(width: width, height: 220)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(text: "Hello", content: {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Button 1")
            })
        }, close: {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("X")
            })
        })
    }
}
