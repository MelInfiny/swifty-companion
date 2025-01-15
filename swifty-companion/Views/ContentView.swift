//
//  ContentView.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//

import SwiftUI

struct ContentView: View {
        
    @StateObject var userModel = UserViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("42backg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("42_logo")
                        .scaledToFit()
                        .opacity(0.9)
                    
                    Text("Welcome to Swifty Companion")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .padding()
                
                    SearchBarView(userModel: userModel)
                        .frame(width: 400, height: 80)
                        .padding(.bottom, 150)
                        .navigationDestination(isPresented: .constant(userModel.foundUser != nil)) {
                                UserView(userModel: userModel)
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
