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
                case .success(let profileImageURL):
                    let avatarURL = profileImageURL.profileImage.small
                    self.avatarURL = avatarURL
                    completion(.success(avatarURL))
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
        guard let defaultBaseURL = URL(string: Constants.defaultBaseURL) else {
            preconditionFailure("Не удалось создать baseUrl")
        }
        
        var urlComponents = URLComponents()
        urlComponents.path = "/users/\(username)"
        
        guard let url = urlComponents.url(relativeTo: defaultBaseURL)
        else {
            assertionFailure("Не удается создать URL-адрес аватара")
            return URLRequest(url: URL(string: "")!)
        }
        guard let token = OAuth2TokenStorage.shared.token else {
            assertionFailure("Не удалось создать токен")
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
}
