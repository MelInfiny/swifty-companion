//
//  TokenManager.swift
//  swifty-companion
//
//  Created by m1 on 03/01/2025.
//
import Foundation

class TokenManager {
    private var accessToken: String?
    private var refreshToken: String?
    private var tokenExpirationDate: Date?

    func getToken() async -> String? {
        if let accessToken = accessToken, let expiration = tokenExpirationDate, expiration > Date() {
            return accessToken
        }
        
        if let refreshToken = refreshToken {
            return await refreshAccessToken(refreshToken: refreshToken)
        }
        return await fetchToken()
    }
    
    // Récupérer un nouveau token depuis l'API
    func fetchToken() async -> String? {
        guard let clientId = ProcessInfo.processInfo.environment["42uid"],
              let clientSecret = ProcessInfo.processInfo.environment["42pass"] else {
            print("Error: Missing credentials in environment variables")
            return nil
        }
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else {
            print("Error: Invalid URL from 42 API")
            return nil
        }
        let tokenRequest = TokenRequest(
            grantType: "client_credentials",
            clientId: clientId,
            clientSecret: clientSecret
        )
        guard let requestData = try? JSONEncoder().encode(tokenRequest) else {
            print("Error: Failed to encode token request as JSON")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            
            self.accessToken = tokenResponse.accessToken
            self.refreshToken = tokenResponse.refreshToken
            self.tokenExpirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
            
            return tokenResponse.accessToken
        } catch {
            print("Erreur lors de la récupération du token: \(error)")
            return nil
        }
    }
    
    // Renouveler le token avec le refresh token
    private func refreshAccessToken(refreshToken: String) async -> String? {
        guard let clientId = ProcessInfo.processInfo.environment["42uid"],
              let clientSecret = ProcessInfo.processInfo.environment["42pass"] else {
            print("Erreur: 42uid ou 42pass manquant dans les variables d'environnement")
            return nil
        }
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else {
            print("Erreur: URL invalide pour renouveler le token")
            return nil
        }
        let bodyParameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": clientId,
            "client_secret": clientSecret
        ]
        let body = bodyParameters.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            
            // Mettre à jour le token, le refresh token et la date d'expiration
            self.accessToken = tokenResponse.accessToken
            self.refreshToken = tokenResponse.refreshToken
            self.tokenExpirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
            
            return tokenResponse.accessToken
        } catch {
            print("Erreur lors du renouvellement du token: \(error)")
            return nil
        }
    }
}

// MARK: - TOKEN REQUEST
struct TokenRequest: Codable {
    let grantType: String
    let clientId: String
    let clientSecret: String
    
    enum CodingKeys: String, CodingKey {
        case grantType = "grant_type"
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
}

// MARK: TOKEN RESPONSE
struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
    }
}
