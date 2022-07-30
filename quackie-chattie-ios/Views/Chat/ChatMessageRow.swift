//
//  ChatMessageRow.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/25/22.
//

import Foundation
import SwiftUI

struct ChatMessageRow: View {
    let message: Message
    let isIncoming: Bool
    let isLasFromContact: Bool
    
    private func chatBubbleTriangle(width: CGFloat, height: CGFloat, isIncoming: Bool) -> some View {
        Path { path in
            path.move(to: CGPoint(x: isIncoming ? 0 : width, y: height * 0.5))
            path.addLine(to: CGPoint(x: isIncoming ? width : 0, y : height))
            path.addLine(to: CGPoint(x: isIncoming ? width : 0, y : 0))
            path.closeSubpath()
        }
        .fill(isIncoming ? Color.bgColor : Color.red)
        .frame(width: width, height: height)
        .shadow(color: .red, radius: 2, x: 0, y: 1)
        .zIndex(10)
        .clipped()
        .padding(.trailing, isIncoming ? -1 : 10)
        .padding(.leading, isIncoming ? 10 : -1)
        .padding(.bottom, 12)
    }
    
    private var chatBubble: some View {
        RoundedRectangle(cornerRadius: 6)
            .foregroundColor(isIncoming ? .red : .red)
            .shadow(color: .red, radius: 2, x: 0, y: 1)
    }
    
    private var text: some View {
        Text(message.message_text)
            .padding([.leading, .trailing], 10)
            .font(Font.custom("modeseven", size: 14))
            .foregroundColor(isIncoming ? .cyan : .red)
    }
    
    private var sender: some View {
        Text(message.sender)
            .padding([.leading], 5)
            .font(Font.custom("modeseven", size: 12))
            .foregroundColor(.roseyBrown)
    }
    
    private var lastSender: some View {
        Text(message.sender)
            .padding([.leading], 5)
            .font(Font.custom("modeseven", size: 12))
            .foregroundColor(Color.roseyBrown)
        
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if isIncoming {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        if isLasFromContact {
                            lastSender
                        } else {
                            sender
                        }
                    }
                    text
                }
                Spacer()
            } else {
                Spacer()
                text
            }
        }
    }
}

struct ChatMessage_Previews: PreviewProvider {
    private static let chatMessage = Message(
        sender: "Bob",
        message_text: "Come stai oggi?",
        room_name: "YO MAMA")
    
    private static let chatMessage1 = Message(
        sender: "Mark",
        message_text: "Sono stanco a basta",
        room_name: "YO MAMA")
    
    static var previews: some View {
        Group {
            ChatMessageRow(message: chatMessage, isIncoming: true, isLasFromContact: true).previewLayout(.fixed(width: 300, height: 200))
            ChatMessageRow(message: chatMessage1, isIncoming: true, isLasFromContact: false).previewLayout(.fixed(width: 300, height: 200))
            ChatMessageRow(message: chatMessage, isIncoming: false, isLasFromContact: true).previewLayout(.fixed(width: 300, height: 200))
        }
    }
}
