import UIKit

final class OAuth2Service {
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage.shared.token
        }
        set {
            OAuth2TokenStorage.shared.token = newValue
        }
    }
    
    private func makeOAuthTokenRequest(code: String?) -> URLRequest? {
        guard let code = code else {
            print("Authorization code is nil")
            return nil
        }
        var urlComponents = URLComponents()
        urlComponents.path = Constants.authPath
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents.url(relativeTo: Constants.defaultBaseURL) else {
            print("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(with code: String,
                         completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(URLError(.badURL)))
            print("Authorization code is nil or failed to create URL")
            return
        }
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    OAuth2TokenStorage.shared.token = tokenResponse.accessToken
                    completion(.success(tokenResponse.accessToken ?? "accessToken"))
                } catch {
                    completion(.failure(error))
                    print("Failed to decode OAuthTokenResponseBody")
                }
            case .failure(let error):
                completion(.failure(error))
                print("Failed to fetch OAuth token")
            }
        }
        task.resume()
    }
}
