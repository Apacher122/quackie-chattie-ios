//
//  ChatTextField.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/25/22.
//

import Foundation
import SwiftUI

struct ChatTextField: View {
    let sendAction: (String) -> Void
    
    @State private var messageText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white)
            
            HStack {
                TextField("Start Quackin...", text: $messageText)
                    .textFieldStyle(.automatic)
                    .font(Font.custom("modeseven",size:16))
                    .foregroundColor(.cyan)
                    .frame(height:60)
                    .onSubmit {
                        sendButtonTapped()
                    }
                
                Button(action: sendButtonTapped) {
                    Image("sendbutton")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.leading, 16)
                }
            }
            .padding([.leading, .trailing])
            .background(Color.bgColor)
        }.frame(height: 60)
    }
    
    private func sendButtonTapped() {
        sendAction(messageText)
        messageText = ""
    }
}

struct ChatTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ChatTextField(sendAction: {_ in})
        }.previewLayout(.fixed(width: 300, height: 80))
    }
}
