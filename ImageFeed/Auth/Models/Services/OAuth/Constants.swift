import Foundation
enum Constants {
    static let accessKey = "yPUiy8u6VaVK_YM1ajfwM7Fb6SmFKDNHjzrht8dhhyk"
    static let secretKey = "xkBRUdwBpd51Kx82IfRZdkcJOmxcUd70ZeUSHnc2Yh4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let authPath: String = "oauth/token/"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
