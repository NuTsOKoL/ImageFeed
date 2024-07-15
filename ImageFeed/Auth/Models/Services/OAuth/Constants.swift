import Foundation
enum Constants {
    static let accessKey = "yPUiy8u6VaVK_YM1ajfwM7Fb6SmFKDNHjzrht8dhhyk"
    static let secretKey = "xkBRUdwBpd51Kx82IfRZdkcJOmxcUd70ZeUSHnc2Yh4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let authPath: String = "oauth/token/"
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
