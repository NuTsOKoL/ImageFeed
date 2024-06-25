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

struct ProfileResult: Codable {
    let userName: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    private enum Codingkeys: String, CodingKey {
        case userName
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(result: ProfileResult) {
        self.userName = result.userName
        self.name = ("\(result.firstName) \(result.lastName ?? "")")
        self.loginName = "@\(result.userName)"
        self.bio = ("\(result.bio ?? "")")
    }
}
