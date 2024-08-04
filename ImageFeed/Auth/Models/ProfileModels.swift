import Foundation

struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(result: ProfileResult) {
        self.userName = result.userName
        self.name = ("\(result.firstName ?? "") \(result.lastName ?? "")")
        self.loginName = "@\(result.userName)"
        self.bio = result.bio
    }
}
