import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    
    private var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        return userNameLabel
    }()
    private var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.text = "@ekaterina_nov"
        nickNameLabel.textColor = .gray
        nickNameLabel.font = UIFont.systemFont(ofSize: 13)
        return nickNameLabel
    }()
    private var profileDescription: UILabel = {
        let profileDescription = UILabel()
        profileDescription.text = "Hello world!"
        profileDescription.textColor = .white
        profileDescription.font = UIFont.systemFont(ofSize: 13)
        return profileDescription
    }()
    private let imageView: UIImageView = {
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView (image: profileImage)
        imageView.tintColor = .gray
        return imageView
    }()
    private let logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = .red
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        [userNameLabel,
         nickNameLabel,
         profileDescription,
         logoutButton,
         imageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  20),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            userNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            userNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nickNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nickNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            profileDescription.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            profileDescription.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    private func updateAvatar() {
        guard let profileImageUrl = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageUrl) else { return }
        let processor = RoundCornerImageProcessor (cornerRadius: 35)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "placeholder.jpeg"),
                              options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
        
        updateProfileDetails(profile: profileService.profile)
        
        updateAvatar()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                updateAvatar()
            }
    }
    
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else {return}
        self.userNameLabel.text = profile.name
        self.nickNameLabel.text = profile.loginName
        self.profileDescription.text = profile.bio
    }
    
    @objc private func didTapButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
}
