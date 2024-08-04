import UIKit
import ProgressHUD
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageServise = ProfileImageService.shared
    private var isFirstLaunch = true
    private let splashLogoImage: UIImageView = {
        let image = UIImage(named: "Vector")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLaunch {
            if oAuth2TokenStorage.token != nil {
                guard let token = oAuth2TokenStorage.token else { return }
                fetchProfile(token: token)
            } else {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {fatalError("Invalid Configuration")}
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                self.present(authViewController, animated: true)
            }
        }
        isFirstLaunch = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func addSubview() {
        view.addSubview(splashLogoImage)
        splashLogoImage.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            splashLogoImage.heightAnchor.constraint(equalToConstant: 78),
            splashLogoImage.widthAnchor.constraint(equalToConstant: 75),
            splashLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    //MARK: - Private Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { assertionFailure("Invalid Configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
    }
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(with: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let accessToken):
                self.oAuth2TokenStorage.token = accessToken
                self.fetchProfile(token: accessToken)
                UIBlockingProgressHUD.dismiss()
            case .failure(let errorFetchOAuthToken):
                print("Ошибка при получении OAuth токена: \(errorFetchOAuthToken.localizedDescription)")
                self.showAlertOAuth2Token(with: errorFetchOAuthToken)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func fetchProfileImage(userName: String) {
        profileImageServise.fetchProfileImageURL(username: userName) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure(let errorFetchProfile):
                print("Ошибка при получении fetchProfile токена: \(errorFetchProfile.localizedDescription)")
                self.showAlertProfile(with: errorFetchProfile)
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.fetchProfileImage(userName: profile.userName)
            case .failure(let errorFetchProfile):
                print("Ошибка при получении fetchProfile токена: \(errorFetchProfile.localizedDescription)")
                self.showAlertProfile(with: errorFetchProfile)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    //MARK: Alert
    private func showAlertProfile(with errorFetchProfile: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось получить Профиль пользователя",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertOAuth2Token(with errorFetchOAuth2Token: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось получить Токен",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
