//
//  SearchBarView.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//

import SwiftUI

struct SearchBarView: View {
        
    @State private var searchText: String = ""
    @State private var showAlert: Bool = false
    @FocusState private var isSearch : Bool
    
    @ObservedObject var userModel: UserViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                TextField("Enter login...", text: $searchText)
                    .focused($isSearch)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                    .onSubmit {
                        submitUser()
                    }
                
                if isSearch {
                    Button(action: {
                        isSearch = false
                        searchText = ""
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.gray)
                    })
                }
            }
            .alert("No user found", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
            .padding(.horizontal, 20)
        }
    }
    
    func submitUser() {
        Task {
            userModel.resetData()
            await userModel.getUserByFilter(filterKey: "login", filterValue: searchText.lowercased())
            if userModel.userId != nil {
                searchText = ""
                await userModel.getUserById()
            } else {
                showAlert = true
            }
        }
    }
}


#Preview {
    let testModel = UserViewModel()
    return SearchBarView(userModel: testModel)
}
