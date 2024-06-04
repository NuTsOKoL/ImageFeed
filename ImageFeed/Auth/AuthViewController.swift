import UIKit
final class AuthViewController: UIViewController {
    private let activeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activeButton)
        setupConstraints()
        configureAppearance()
    }
 
    private func setupConstraints() {
        NSLayoutConstraint.activate([
                  activeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                  activeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                  activeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -124),
                  activeButton.heightAnchor.constraint(equalToConstant: 48)
              ])
      }
    private func configureAppearance() {
        
    }
}
