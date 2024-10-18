import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private let imagesListService = ImagesListService.shared
    weak var delegate: ImagesListCellDelegate?
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.setImage(UIImage(named: isLiked ? "like_button_on" : "like_button_off"), for: .normal)
    }
    @IBAction func onLikeButtonTapped() {
        delegate?.imageListCellDidTapLike(self)
    }
}
