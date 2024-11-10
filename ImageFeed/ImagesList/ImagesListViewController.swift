import UIKit
import Kingfisher
import ProgressHUD

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(_ indexPaths: [IndexPath])
    func setLikeLoadingState(_ isLoading: Bool)
    func setCellIsLiked(_ cell: IndexPath, _ isLiked: Bool)
    func showAlert(title: String, message: String)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    var presenter: ImagesListPresenterProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.didPhotosUpdate()
        }
        
        presenter?.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            // полноэкранный режим
            viewController.photo = presenter?.photos[indexPath.row]
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // картинка
        guard
            let photo = presenter?.photos[indexPath.row],
            let imageUrl = URL(string: photo.thumbImageURL)
        else { return }
        
        // Kingfisher
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "scribble-placeholder"))
        
        // градиент
        let gradientLayer = CAGradientLayer() // создаём слой градиента
        let gradientHeight = 30.0
        let marginTopAndBottom = 8.0
        gradientLayer.frame = CGRect(x: 0, y: cell.frame.height - gradientHeight - marginTopAndBottom, width: cell.cellImage.bounds.width, height: gradientHeight) // настраиваем положение слоя
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.ypBlack.withAlphaComponent(0.2).cgColor] // настраиваем цвета слоя
        gradientLayer.locations = [0.0, 1.0]
        cell.cellImage.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer }) // чистим слои
        cell.cellImage.layer.addSublayer(gradientLayer) // добавляем слой градиента к изображению
        
        // дата
        cell.dateLabel.text = photo.createdAt != nil ? dateFormatter.string(from: photo.createdAt!) : ""
        
        // лайк
        cell.likeButton.setImage(UIImage(named: photo.isLiked ? "like_button_on" : "like_button_off"), for: .normal)
    }
    
    func updateTableViewAnimated(_ indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

// TableViewDataSource Protocol
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// TableViewDelegate Protocol
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getCellHeight(tableView.bounds.width, indexPath.row) ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let testMode = ProcessInfo.processInfo.arguments.contains("testMode")
        if testMode { return } // отключаем пагинацию в тестовом режиме
        if indexPath.row + 1 == presenter?.photos.count {
            presenter?.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.imageListCellDidTapLike(indexPath)
    }
    
    func setCellIsLiked(_ indexPath: IndexPath, _ isLiked: Bool) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        cell.setIsLiked(isLiked)
    }
    
    
    func setLikeLoadingState(_ isLoading: Bool) {
        if isLoading {
            // Покажем лоадер
            UIBlockingProgressHUD.show()
        } else {
            // Уберём лоадер
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
