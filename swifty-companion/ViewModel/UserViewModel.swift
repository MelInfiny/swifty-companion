//
//  UserViewModel.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    
    @Published var userId: Int? = nil
    @Published var foundUser: User? = nil
    @Published var projects: [Project] = []
    @Published var allCursus: [CursusUser] = []
    @Published var cursusUser: CursusUser? = nil

    private let apiService = APIService()

    
    // MARK: GET USER BY FILTER
    func getUserByFilter(filterKey: String, filterValue: String) async {
         do {
             let users = try await apiService.fetchFilteredUsers(filterKey: filterKey, filterValue: filterValue)
             if !users.isEmpty && users.count == 1 {
                 self.userId = users.first?.id
             }
         } catch {
             errorMessage = "Failed to fetch users: \(error.localizedDescription)"
             print(errorMessage!)
             userId = nil
             errorMessage = nil
         }
     }
    
    // MARK: GET USER BU THEIR ID
    func getUserById() async {
        guard let id = userId else {
            errorMessage = "No user id found"
            return
        }
        do {
            if let user = try await apiService.fetchUserById(userId: id) {
                self.foundUser = user
                self.projects = user.projectsUsers ?? []
                self.allCursus = user.cursusUsers ?? []
                self.cursusUser = allCursus.first ?? nil
            }
        } catch {
            errorMessage = "Failed to fetch user at id: \(error.localizedDescription)"
            print(errorMessage!)
            foundUser = nil
            errorMessage = nil
        }
    }
    
    // MARK: RESET STRUCTURE DATA
    func resetData() {
        foundUser = nil
        userId = nil
        projects = []
        allCursus = []
        cursusUser = nil
        errorMessage = nil
    }
}
