//
//  ApiManager.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//

import Foundation

class APIService {
    let token = TokenManager()
    
    private func getToken() async throws -> String {
        guard let token = await token.getToken() else {
            throw APIError.tokenUnavailable
        }
        return token
    }

    func makeRequest(endpoint: String, method: String = "GET", body: Data? = nil) async throws -> Data {
        let token = try await getToken()
        
     //   print("TOKEN : \(token)")
        guard let url = URL(string: "https://api.intra.42.fr/v2" + endpoint) else {
            throw APIError.other(message: "Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(statusCode: nil)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        return data
    }
    
    
    func fetchFilteredUsers(filterKey: String, filterValue: String) async throws -> [User] {
        let allowedFilters = [
            "id", "login", "email", "created_at", "updated_at",
            "pool_year", "pool_month", "kind", "status", "primary_campus_id",
            "first_name", "last_name", "alumni?", "staff?"
        ]
        guard allowedFilters.contains(filterKey) else {
            throw APIError.invalidFilterKey
        }
        let endpoint = "/users?filter[\(filterKey)]=\(filterValue)"
        let data = try await makeRequest(endpoint: endpoint)
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([User].self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    func fetchUserById(userId: Int) async throws -> User? {
        let endpoint = "/users/\(userId)"
        let data = try await makeRequest(endpoint: endpoint)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(User.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    enum APIError: Error {
        case tokenUnavailable
        case invalidResponse(statusCode: Int?)
        case decodingError
        case invalidURL
        case invalidFilterKey
        case other(message: String)
    }
    
    
}
