//
//  PopUpView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct PopUpView<Content: View>: View {
    let text: String
    @ViewBuilder var content: Content

    var body: some View {

        Color.black.opacity(0.2).ignoresSafeArea()
        
        VStack(spacing: 10) {
            Text(text)
                .bold()
        
            Spacer()
        
            content
        }
        .padding()
        .frame(width: 240, height: 220)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(text: "Hello") {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Button 1")
            })
        }
    }
}
