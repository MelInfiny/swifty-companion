//
//  Untitled.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//

import SwiftUI

struct UserView: View {
    
    @State private var buttonClicked: String? = nil
    @State private var selectedTab: Int = 0
    
    @ObservedObject var userModel: UserViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                
                VStack(alignment: .center) {
                    if let imageUrl = userModel.foundUser?.image?.versions?.medium ?? userModel.foundUser?.image?.link,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: geometry.size.width, height: geometry.size.height / 3)                                .shadow(radius: 10)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                    } else {
                        Image("unknown")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: geometry.size.width, height: geometry.size.height / 3)                                .shadow(radius: 10)
                    }
                    
                    if let user = userModel.foundUser {
                        Text("\(user.displayName)")
                            .font(.largeTitle)
                        Text("\(user.login)")
                            .font(.title)
                            .foregroundStyle(.black.opacity(0.7))
                    }
                }
                .padding(.bottom, 10)
                HStack {
                    createButton(title: "About", alignment: .leading, tag: 0, isClicked: $selectedTab) {
                    }
                    .padding(.leading, 10)
                    
                    createButton(title: "Projets", alignment: .center, tag: 1,  isClicked: $selectedTab) {
                    }
                    
                    createButton(title: "Skills", alignment: .trailing, tag: 2, isClicked: $selectedTab) {
                    }
                    .padding(.trailing, 10)
                    
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.10)
                }
                .background(Color("dark_blue").opacity(0.7))
                
                TabView(selection: $selectedTab) {
                    AboutView(userModel: userModel)
                        .tag(0)
                    
                    ProjectView(userModel: userModel)
                        .tag(1)
                    
                    SkillView(userModel: userModel)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }
    
    func createButton(
        title: String,
        alignment: HorizontalAlignment,
        tag: Int,
        isClicked: Binding<Int>,
        action: @escaping() -> Void
    ) -> some View {
        Text(title)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(isClicked.wrappedValue == tag ? .white : .black)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isClicked.wrappedValue == tag ? Color.darkBlue.opacity(0.9) : Color.darkBlue.opacity(0.6))
            )
            .onTapGesture {
                isClicked.wrappedValue = tag
                action()
            }
    }

}


#Preview {
    let testModel = UserViewModel()
    Task {
        await testModel.getUserByFilter(filterKey: "login", filterValue: "enolbas")
        await testModel.getUserById()
    }
    return UserView(userModel: testModel)
}
