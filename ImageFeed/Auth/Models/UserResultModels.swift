import Foundation

struct UserResult: Codable {
    let profileImage: ImageResult
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageResult: Codable {
    let small: String
    let medium: String
    let large: String
}
