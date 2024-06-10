import Foundation
enum Constants {
   static let accessKey = "@VXFSY5IC_I1qpNuOMAg03ZARKvKAw6yBnnJWQu8S7U"
    static let secretKey = "KONSYkykFFdqsK2k8RJpGZSPth2aA0NG0shHnCiEF-I"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let authPath: String = "oauth/token/"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let apiURL = URL(string: "https://api.unsplash.com/")
}
