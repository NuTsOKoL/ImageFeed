import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    
    private enum Keys: String {
        case token
    }
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let keyChain = KeychainWrapper.standard
    
    var token: String? {
        get {
            keyChain.string(forKey: Keys.token.rawValue)
        }
        set {
            if let token = newValue {
                keyChain.set(token, forKey: Keys.token.rawValue)
            } else {
                keyChain.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
    
    func logout() {
        keyChain.removeObject(forKey: Keys.token.rawValue)
    }
}
