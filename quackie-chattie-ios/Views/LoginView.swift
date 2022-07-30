//
//  ContentView.swift
//  quackie-chattie-ios
//
//  Created by Rey Aparece on 7/13/22.
//

import SwiftUI
import Foundation
import FirebaseAuth
import Firebase
import SocketIO

struct CustomColors {
    static let backgroundColor = Color("bg_color")
}


struct LoginView: View {
    @State private var chatContent = ""
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            HStack{
                Image("froglogo")
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                    .frame(width: 128, height:128)
                    .background(
                        Circle()
                            .fill(.red)
                    )
                
                Text("QuackieChattie")
                        .font(Font.custom("modeseven", size:28))
                        .foregroundColor(.textColor)
                        .lineLimit(1)
                    
            }
            Spacer()
                .frame(height:100)
            Text("Sign in with Google")
                .font(Font.custom("modeseven", size:16))
                .foregroundColor(.textColor)
            Spacer()
                .frame(height:50)
            
            Button {
                viewModel.signIn()
            } label: {
                Text("LOGIN")
                    .font(Font.custom("modeseven", size:32))
                    .foregroundColor(.red)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.bgColor)
    }
}

extension View{
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

extension Color {
    static let textColor = Color("cyan")
    static let bgColor = Color("bg_color")
    static let roseyBrown = Color("roseyBrown")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

