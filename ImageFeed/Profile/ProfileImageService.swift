import UIKit
final class ProfileImageService {
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUserName: String?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUserName == username {return}
        task?.cancel()
        lastUserName = username
        
        let request = makeRequest(username: username)
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let profileImage):
                    let profileImageURL = profileImage.profileImage.small
                    self.avatarURL = profileImageURL
                    completion(.success(profileImageURL))
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL])
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastUserName = nil
                }
            }
        }
            self.task = nil
        task.resume()
    }
}

extension ProfileImageService {
    private func makeRequest(username: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.path = "/users/\(username)"
        guard let url = urlComponents.url(relativeTo: Constants.defaultBaseURL) else {fatalError("Failed to create URL for avatar Image") }
        guard let token = OAuth2TokenStorage.shared.token else {fatalError("Failed to create Token")}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
