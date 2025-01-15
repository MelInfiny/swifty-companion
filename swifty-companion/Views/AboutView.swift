//
//  AboutView.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//

import SwiftUI

struct AboutView: View {
    
    @ObservedObject var userModel: UserViewModel
    
    var body: some View {
        VStack {
            if let user = userModel.foundUser {
                HStack(spacing: 0) {
                    ForEach(["Wallet", "Status", "Ev.P"], id: \.self) { column in
                        VStack {
                            Text(column)
                                .font(.title3)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .foregroundColor(.white)
                            
                            if column == "Wallet" {
                                Text("\(user.wallet ?? 0)")
                            } else if column == "Status" {
                                Text((user.isStaff ?? false) ? "Staff" : "Student")
                            } else {
                                Text("\(user.correctionPoint ?? 0)")
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
                .padding(.horizontal, 10)
                
            } else {
                Text("No informations available.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            VStack {
                Text("\(userModel.foundUser?.location ?? "Unaivalable")")
                    .font(.title)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
            .padding(.horizontal, 10)
            
            VStack {
                Text("\(userModel.foundUser?.email ?? "??")")
                    .font(.title3)
                
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
            .padding(.horizontal, 10)
            
            VStack {
                if let user = userModel.foundUser {
                    if let isAlumni = user.isAlumni, isAlumni{
                        Text("ALUMNI")
                            .font(.headline)
                            .foregroundColor(.green)
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(10)
                            .padding(.horizontal, 10)
                        
                    } else if let cursusUser = getCursusFor42Cursus() {
                        if cursusUser.blackholedAt != nil {
                            Text(" BLACKHOLED")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(10)
                                .padding(.horizontal, 10)
                        }
                    }
                }
            }
           Spacer()
        }        
    }
    
    func progressValue(level: Double) -> Double {
        let decimalPart = level - Double(floor(level))
        return decimalPart / 1
    }
    
    func getCursusFor42Cursus() -> CursusUser? {
        for cursusUser in userModel.allCursus {
            if cursusUser.cursusID == 21 {
                return cursusUser
            }
        }
        return nil
    }
}

#Preview {
    let testModel = UserViewModel()
    Task {
        await testModel.getUserByFilter(filterKey: "login", filterValue: "enolbas")
        await testModel.getUserById()
    }
    return AboutView(userModel: testModel)
}
