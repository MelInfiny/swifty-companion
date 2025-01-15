//
//  SkillView.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//

import SwiftUI

struct SkillView: View {
    
    @State private var selectedCursusId: Int? = nil
    
    @ObservedObject var userModel: UserViewModel
    
    var body: some View {
        
        VStack {
            
            if let cursusUser = userModel.cursusUser {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            LevelView(level: cursusUser.level ?? 0)
                            if let skills = cursusUser.skills, !skills.isEmpty {
                                VStack(alignment: .leading) {
                                    ForEach(skills) { skill in
                                        SkillRowView(skill: skill)
                                    }
                                }
                                .padding()
                            }
                            
                        }
                    }
                }
            }
        } 
        .padding(.top, 20)
    }
}

struct LevelView: View {
    let level: Double
    
    var body: some View {
        VStack {
            ZStack {
                ProgressView(value: progressValue(), total: 1)
                    .progressViewStyle(LinearProgressViewStyle(tint: .darkBlue))
                    .background(Color.gray.opacity(0.2))
                    .scaleEffect(x: 1, y: 8, anchor: .center)
                    .padding(.horizontal, 10)
                
                Text("Level : \(level, specifier: "%.2f")%")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
    func progressValue() -> Double {
        let decimalPart = level - Double(floor(level))
        return decimalPart / 1
    }
}

struct SkillRowView: View {
    let skill: Skill
    
    var body: some View {
        HStack {
            Text(skill.name ?? "N/A")
                .font(.subheadline)
            Spacer()
            Text(String(format: "Level: %.2f", skill.level ?? 0))
                .font(.footnote)
                .foregroundColor(.black.opacity(0.7))
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let testModel = UserViewModel()
    Task {
        await testModel.getUserByFilter(filterKey: "login", filterValue: "enolbas")
        await testModel.getUserById()
    }
    return SkillView(userModel: testModel)
}
