//
//  PopUpView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct PopUpView<Content: View, RightButton: View, LeftButton: View>: View {
    let text: LocalizedStringKey
    @ViewBuilder var content: Content
    @ViewBuilder var rightButton: RightButton
    @ViewBuilder var leftButton: LeftButton

    var width: CGFloat = 240
    var height: CGFloat = 220

    init(text: LocalizedStringKey,
         width: CGFloat = 240,
         height: CGFloat = 220,
         @ViewBuilder content: () -> Content,
         @ViewBuilder leftButton: () -> LeftButton,
         @ViewBuilder rightButton: () -> RightButton)
    {
        self.text = text
        self.content = content()
        self.leftButton = leftButton()
        self.rightButton = rightButton()
        self.width = width
        self.height = height
    }

    var body: some View {
        Color.black.opacity(0.2)
            .ignoresSafeArea()

        VStack(spacing: 5) {
            ZStack {
                HStack {
                    Spacer()

                    Text(text)
                        .bold()

                    Spacer()
                }

                HStack {
                    Spacer()
                        .frame(width: 5)

                    leftButton

                    Spacer()

                    rightButton

                    Spacer()
                        .frame(width: 5)
                }
            }

            Spacer()
                .frame(height: 5)

            content

            Spacer()
        }
        .padding()
        .frame(width: width, height: height)
        .panelled(cornerRadius: 20)
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(text: "Hello", content: {
            Button(action: /*@START_MENU_TOKEN@*/ {}/*@END_MENU_TOKEN@*/, label: {
                Text("Button 1")
            })
        }, leftButton: {
            Button(action: /*@START_MENU_TOKEN@*/ {}/*@END_MENU_TOKEN@*/, label: {
                Text("Cancel")
            })
        }, rightButton: {
            Button(action: /*@START_MENU_TOKEN@*/ {}/*@END_MENU_TOKEN@*/, label: {
                Text("Add")
            })
        })
    }
}
