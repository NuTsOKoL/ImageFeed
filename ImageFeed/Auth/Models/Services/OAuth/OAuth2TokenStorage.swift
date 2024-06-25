import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    private let keyChain = KeychainWrapper.standard
    private let accessToken = "accessToken"
    
    var token: String? {
        get {
            keyChain.string(forKey: accessToken)
        }
        set {
            if let token = newValue {
                keyChain.set(token, forKey: accessToken)
            } else {
                keyChain.removeObject(forKey: accessToken)
            }
        }
    }
}
