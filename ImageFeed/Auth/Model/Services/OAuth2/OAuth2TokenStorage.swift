import Foundation

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
   
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            return userDefaults.string(forKey: "accessToken")
        }
        set {
            userDefaults.setValue(newValue, forKey: "accessToken")
            print("Your token is \(token ?? "") is saved")
        }
    }
    private let userDefaults = UserDefaults.standard
}
