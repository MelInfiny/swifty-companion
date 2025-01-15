//
//  User.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//

import Foundation

// MARK: - Main User Structure
struct User: Codable {
    let id: Int
    let email: String?
    let login: String
    let firstName: String?
    let lastName: String?
    let usualFullName: String?
    let usualFirstName: String?
    let url: String
    let phone: String?
    let displayName: String
    let kind: String?
    let image: ImageU?
    let isStaff: Bool?
    let correctionPoint: Int?
    let poolMonth: String?
    let poolYear: String?
    let location: String?
    let wallet: Int?
    let anonymizeDate: String?
    let dataErasureDate: String?
    let createdAt: String?
    let updatedAt: String?
    let alumnizedAt: String?
    let isAlumni: Bool?
    let isActive: Bool?
    let groups: [GroupUser]?
    let cursusUsers: [CursusUser]?
    let projectsUsers: [Project]?
    
    enum CodingKeys: String, CodingKey {
        case id, email, login
        case firstName = "first_name"
        case lastName = "last_name"
        case usualFullName = "usual_full_name"
        case usualFirstName = "usual_first_name"
        case url, phone, displayName = "displayname", kind
        case image
        case isStaff = "staff?"
        case correctionPoint = "correction_point"
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case location, wallet
        case anonymizeDate = "anonymize_date"
        case dataErasureDate = "data_erasure_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alumnizedAt = "alumnized_at"
        case isAlumni = "alumni?"
        case isActive = "active?"
        case groups, cursusUsers = "cursus_users", projectsUsers = "projects_users"
    }
}

// MARK: - User Image
struct ImageU: Codable {
    let link: String?
    let versions: ImageVersionsU?
}

// MARK: - Image Versions
struct ImageVersionsU: Codable {
    let large: String?
    let medium: String?
    let small: String?
    let micro: String?
}

// MARK: - Group User
struct GroupUser: Codable {
    let id: Int
    let name: String?
}

// MARK: - Cursus User
struct CursusUser: Codable, Identifiable {
    let id: Int
    let beginAt: String?
    let endAt: String?
    let grade: String?
    let level: Double?
    let skills: [Skill]?
    let cursusID: Int?
    let hasCoalition: Bool?
    let blackholedAt: String?
    let createdAt: String?
    let updatedAt: String?
    let user: NestedUser?
    let cursus: CursusU?
    
    enum CodingKeys: String, CodingKey {
        case id
        case beginAt = "begin_at"
        case endAt = "end_at"
        case grade, level, skills
        case cursusID = "cursus_id"
        case hasCoalition = "has_coalition"
        case blackholedAt = "blackholed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case user, cursus
    }
}

// MARK: - Skill
struct Skill: Codable, Identifiable {
    let id: Int
    let name: String?
    let level: Double?
}

// MARK: - Nested User (for Cursus User)
struct NestedUser: Codable {
    let id: Int
    let email: String?
    let login: String?
    let firstName: String?
    let lastName: String?
    let usualFullName: String?
    let usualFirstName: String?
    let url: String?
    let phone: String?
    let displayName: String?
    let kind: String?
    let image: ImageU?
    let isStaff: Bool?
    let correctionPoint: Int?
    let poolMonth: String?
    let poolYear: String?
    let location: String?
    let wallet: Int?
    let anonymizeDate: String?
    let dataErasureDate: String?
    let createdAt: String?
    let updatedAt: String?
    let alumnizedAt: String?
    let isAlumni: Bool?
    let isActive: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, email, login
        case firstName = "first_name"
        case lastName = "last_name"
        case usualFullName = "usual_full_name"
        case usualFirstName = "usual_first_name"
        case url, phone, displayName = "displayname", kind
        case image
        case isStaff = "staff?"
        case correctionPoint = "correction_point"
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case location, wallet
        case anonymizeDate = "anonymize_date"
        case dataErasureDate = "data_erasure_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alumnizedAt = "alumnized_at"
        case isAlumni = "alumni?"
        case isActive = "active?"
    }
}

// MARK: - Cursus
struct CursusU: Codable {
    let id: Int
    let createdAt: String?
    let name: String?
    let slug: String?
    let kind: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name, slug, kind
    }
}

// MARK: - Project User
struct Project: Codable, Identifiable {
    let id: Int
    let occurrence: Int?
    let finalMark: Int?
    let status: String?
    let validated: Bool?
    let currentTeamID: Int?
    let project: ProjectU?
    let cursusIDs: [Int]
    let markedAt: String?
    let marked: Bool?
    let retriableAt: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, occurrence
        case finalMark = "final_mark"
        case status
        case validated = "validated?"
        case currentTeamID = "current_team_id"
        case project
        case cursusIDs = "cursus_ids"
        case markedAt = "marked_at"
        case marked
        case retriableAt = "retriable_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Project
struct ProjectU: Codable, Identifiable {
    let id: Int
    let name: String?
    let slug: String?
    let parentID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case parentID = "parent_id"
    }
}
