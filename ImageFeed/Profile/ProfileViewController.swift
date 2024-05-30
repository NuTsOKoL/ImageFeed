import UIKit

final class ProfileViewController: UIViewController {
    private let imageView: UIImageView = {
           let profileImage = UIImage(named: "avatar")
           let imageView = UIImageView (image: profileImage)
           imageView.tintColor = .gray
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        setupConstraints()

        
        let userName = UILabel()
        userName.text = "Екатерина Новикова"
        userName.textColor = .white
        userName.font = UIFont.boldSystemFont(ofSize: 23)
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)
        userName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        userName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        
        let nickname = UILabel()
        nickname.text = "@ekaterina_nov"
        nickname.textColor = .gray
        nickname.font = UIFont.systemFont(ofSize: 13)
        nickname.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickname)
        nickname.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nickname.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8).isActive = true
        
        let profileDescription = UILabel()
        profileDescription.text = "Hello world!"
        profileDescription.textColor = .white
        profileDescription.font = UIFont.systemFont(ofSize: 13)
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileDescription)
        profileDescription.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        profileDescription.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 8).isActive = true
        
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
                  imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                  imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  20),
                  imageView.widthAnchor.constraint(equalToConstant: 70),
                  imageView.heightAnchor.constraint(equalToConstant: 70)
              ])
      }
    @objc private func didTapButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
}
