import Foundation
import UIKit

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
    func didPhotosUpdate()
    func getCellHeight(_ tableViewBoundsWidth: CGFloat, _ photoIndex: Int) -> CGFloat
    func imageListCellDidTapLike(_ indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService = ImagesListService.shared
    
    var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func didPhotosUpdate() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.updateTableViewAnimated(indexPaths)
        }
    }
    
    func getCellHeight(_ tableViewBoundsWidth: CGFloat, _ photoIndex: Int) -> CGFloat {
        let photo = photos[photoIndex]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewBoundsWidth - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func imageListCellDidTapLike(_ indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        view?.setLikeLoadingState(true)
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                self.view?.setCellIsLiked(indexPath, self.photos[indexPath.row].isLiked)
                self.view?.setLikeLoadingState(false)
            case .failure:
                self.view?.setLikeLoadingState(false)
                self.view?.showAlert(title: "Что-то пошло не так :(", message: "Попробуйте ещё раз позже")
            }
        }
    }
}
