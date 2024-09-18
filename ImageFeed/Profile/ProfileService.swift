import UIKit

final class ProfileService {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    private var lastCode: String?
    
    static let shared = ProfileService()
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == token {return}
        task?.cancel()
        lastCode = token
        
        guard let request = makeRequest(token: token) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
            
        }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>)  in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let person = Profile(result: profileResult)
                    completion(.success(person))
                    self.profile = person
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService {
    private func makeRequest(token: String) -> URLRequest? {
        
        guard let url = URL(string: ProfileConstants.urlProfilePath)
        else {
            assertionFailure("Ошибка создания url профиля")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    func cleanProfile() {
        profile = nil
    }
}
