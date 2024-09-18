import Foundation

struct AccessTokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
