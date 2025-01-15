//
//  ProjectView.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//

import SwiftUI

struct ProjectView: View {
    
    @State private var selectedCursusId: Int? = nil
    @ObservedObject var userModel: UserViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Menu {
                    ForEach(userModel.allCursus, id: \.id) { cursus in
                        Button(action: {
                            selectedCursusId = cursus.cursusID
                            userModel.cursusUser = cursus
                        }) {
                            Text(cursus.cursus?.name ?? "Cursus inconnu")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                } label: {
                    Text("\(userModel.allCursus.first(where: { $0.cursusID == selectedCursusId })?.cursus?.name ?? "Cursus inconnu")")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                        )
                        .padding(.horizontal)
                }
                Spacer()
            }
            .padding()
            
            if let selectedId = selectedCursusId {
                if let groupedProjects = groupProjectsByCursusId(projects: userModel.projects) {

                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            if let projectsForSelectedCursus = groupedProjects[selectedId] {

                                if userModel.allCursus.first(where: { $0.cursusID == selectedId }) != nil {
                                        ForEach(projectsForSelectedCursus, id: \.id) { project in
                                            AchievmentView(project: project)
                                        }
                                    
                                    .padding()
                                }
                            } else {
                                Text("No projects available for this cursus.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("No projects available.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            if let cursusUser = userModel.cursusUser {
                selectedCursusId = cursusUser.cursusID
            }
        }
    }
    
    func groupProjectsByCursusId(projects: [Project]) -> [Int: [Project]]? {
        guard !projects.isEmpty else { return nil }
        
        var groupedProjects: [Int: [Project]] = [:]
        
        for project in projects {
            for cursusId in project.cursusIDs {
                if groupedProjects[cursusId] != nil {
                    groupedProjects[cursusId]?.append(project)
                } else {
                    groupedProjects[cursusId] = [project]
                }
            }
        }

        return groupedProjects
    }
}

struct AchievmentView: View {
    let project: Project
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.project?.name ?? "N/A")
                    .font(.headline)
                Text(project.status ?? "?")
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .leading) {
                if let finalMark = project.finalMark {
                    Text("\(finalMark)")
                        .font(.title3)
                        .foregroundColor(finalMark == 0 ? .red : .green)
                } else {
                    Image(systemName: "hourglass")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
            .padding(.leading)
        }
    }
}

#Preview {
    let testModel = UserViewModel()
    Task {
        await testModel.getUserByFilter(filterKey: "login", filterValue: "enolbas")
        await testModel.getUserById()

    }
    return ProjectView(userModel: testModel)
}

