import UIKit

final class ProfileViewController: UIViewController {
    private var label: UILabel?
    private var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView (image: profileImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        self.image = profileImage
        
        let labelName = UILabel()
        labelName.text = "Екатерина Новикова"
        labelName.textColor = .white
        labelName.font = UIFont.boldSystemFont(ofSize: 23)
      
        labelName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelName)
        labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        self.label = labelName
        
        let labelEmail = UILabel()
        labelEmail.text = "@ekaterina_nov"
        labelEmail.textColor = .gray
        labelEmail.font = UIFont.systemFont(ofSize: 13)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelEmail)
        labelEmail.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true
        self.label = labelEmail
        
        let labelStatus = UILabel()
        labelStatus.text = "Hello world!"
        labelStatus.textColor = .white
        labelStatus.font = UIFont.systemFont(ofSize: 13)
        labelStatus.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelStatus)
        labelStatus.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        labelStatus.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 8).isActive = true
        self.label = labelStatus
        
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
    
    @objc private func didTapButton() {
       
        //MARK: как сделать удаляющую картинку?
        image = UIImage(systemName: "person.crop.circle.fill")
       
        
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
}
