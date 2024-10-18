import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastUsername != username else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastUsername = username
        
        guard let request = makeProfileDataRequest(username: username, token: token) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileImageResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let profileImageURL = data.profileImage.large
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL]
                )
            case .failure(let error): completion(.failure(error))
            }
            self.task = nil
            self.lastUsername = nil
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileDataRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURL)/users/\(username)") else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return request
    }
    
    func cleanProfileImage() {
        avatarURL = nil
    }
}

