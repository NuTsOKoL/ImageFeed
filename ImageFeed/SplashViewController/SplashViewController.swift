import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ypBlack
        
        // рисуем интерфейс
        addLogoImgeView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let result):
                    self.fetchProfileImageURL(username: result.username, token: token)
                    self.switchToTabBarController()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: .main)
            let authViewController = storyBoard.instantiateViewController(identifier: "AuthViewController") as? AuthViewController
            
            guard let authViewController else { return }
            
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            
            present(authViewController, animated: true)
        }
    }
    
    private func addLogoImgeView() {
        view.addSubview(logoImageView)
        
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    private func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchProfileImageURL(username: String, token: String) {
        profileImageService.fetchProfileImageURL(username: username, token: token) { result in
            switch result {
            case .success(let result):
                print("fetchProfileImageURL: \(result)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func switchToTabBarController() {
        // Получаем экземпляр `window` приложения
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Неверная конфигурация window")
            return
        }
        
        // Создаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        if let token = storage.token {
            fetchProfile(token) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let result):
                    self.fetchProfileImageURL(username: result.username, token: token)
                    self.switchToTabBarController()
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("Не удалось прочитать токен аутентификации")
        }
    }
}
