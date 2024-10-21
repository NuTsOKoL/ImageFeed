import Foundation

enum Constants {
    static let accessKey = "yPUiy8u6VaVK_YM1ajfwM7Fb6SmFKDNHjzrht8dhhyk"
    static let secretKey = "xkBRUdwBpd51Kx82IfRZdkcJOmxcUd70ZeUSHnc2Yh4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = "https://api.unsplash.com/"
}
enum OAuthConstants {
    static let baseURL = "https://unsplash.com"
}
enum ProfileConstants {
    static let urlProfilePath = "https://api.unsplash.com/me"
}
enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let urlComponentsPath = "/oauth/authorize/native"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURLString: String, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURLString
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURLString: OAuthConstants.baseURL,
                                 authURLString: WebViewConstants.unsplashAuthorizeURLString)
    }
}
