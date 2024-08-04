import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var storage = OAuth2TokenStorage.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    
    private let avatarImageView = UIImageView()
    private var userNameLabel = UILabel()
    private var nickNameLabel = UILabel()
    private var profileDescription = UILabel()
    private let logoutButton = UIButton()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayer()
        
        [avatarImageView,
         userNameLabel,
         nickNameLabel,
         profileDescription,
         logoutButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    //MARK: Private function
    private func setupLayer() {
        view.backgroundColor = .ypBlack
        configureAvatarImageView()
        configureUserNameLabel()
        configureNickNameLabel()
        configureProfileDescription()
        configureLogoutButton()
        profileImageServiceObserve()
        updateProfileDetails(profile: profileService.profile)
    }
    
   private func configureAvatarImageView() {
       avatarImageView.image = UIImage(named: "") ?? UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = .ypGray
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    
    private func configureUserNameLabel() {
        userNameLabel.text = ""
        userNameLabel.textColor = .ypWhite
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        view.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func configureNickNameLabel() {
        nickNameLabel.text = ""
        nickNameLabel.textColor = .ypGray
        nickNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        view.addSubview(nickNameLabel)
        
        NSLayoutConstraint.activate([
            nickNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nickNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nickNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func configureProfileDescription() {
        profileDescription.numberOfLines = 0
        profileDescription.text = ""
        profileDescription.textColor = .ypWhite
        profileDescription.font = UIFont.systemFont(ofSize: 13, weight: .light)
        view.addSubview(profileDescription)
        
        NSLayoutConstraint.activate([
            profileDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profileDescription.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func configureLogoutButton() {
        logoutButton.setImage(UIImage(named: "logout_button") ?? UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        logoutButton.addTarget(self,
                               action: #selector(Self.didTapLogoutButton),
                               for: .touchUpInside)
        logoutButton.tintColor = .ypRed
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 24),
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55)
        ])
    }
    
    private func updateAvatar() {
        guard
            let profileImageUrl = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageUrl) else { return }
        
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
        
        let processor = RoundCornerImageProcessor (cornerRadius: 35)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(named: "placeholder.jpeg"),
                                    options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    private func profileImageServiceObserve(){
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else {return}
        self.userNameLabel.text = profile.name
        self.nickNameLabel.text = profile.loginName
        self.profileDescription.text = profile.bio
    }
    
    @objc private func didTapLogoutButton() {
        storage.logout()
    }
}
