//
//  PopUpView.swift
//  PainMedsBuddy
//
//  Created by Jules Moorhouse.
//

import SwiftUI

struct PopUpView<Content: View,
    RightButton: View,
    LeftButton: View,
    BottomButton: View>: View
{
    let text: LocalizedStringKey
    @ViewBuilder var content: Content
    @ViewBuilder var rightButton: RightButton
    @ViewBuilder var leftButton: LeftButton
    @ViewBuilder var bottomButton: BottomButton

    var width: CGFloat = 240
    var height: CGFloat = 220

    var body: some View {
        ZStack {
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
                    .frame(height: 5)

                if let bottomButton = bottomButton {
                    bottomButton
                    Spacer()
                        .frame(height: 5)
                }
            }
            .padding()
            .frame(width: width)
            .panelled(cornerRadius: 20)
        }
        .dismissKeyboardOnTap()
        .edgesIgnoringSafeArea(.all)
    }
    
    init(text: LocalizedStringKey,
         width: CGFloat = 240,
         height: CGFloat = 220,
         @ViewBuilder content: () -> Content,
         @ViewBuilder leftButton: () -> LeftButton,
         @ViewBuilder rightButton: () -> RightButton,
         @ViewBuilder bottomButton: () -> BottomButton)
    {
        self.text = text
        self.content = content()
        self.leftButton = leftButton()
        self.rightButton = rightButton()
        self.bottomButton = bottomButton()
        self.width = width
        self.height = height
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
        }, bottomButton: {
            Button(action: /*@START_MENU_TOKEN@*/ {}/*@END_MENU_TOKEN@*/, label: {
                Text("OK")
            })
        })
    }
}
