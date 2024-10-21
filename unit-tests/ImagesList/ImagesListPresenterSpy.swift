import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var fetchPhotosNextPageCalled: Bool = false
    
    var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    
    var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func didPhotosUpdate() {}
    
    func getCellHeight(_ tableViewBoundsWidth: CGFloat, _ photoIndex: Int) -> CGFloat {
        return 0
    }
    
    func imageListCellDidTapLike(_ indexPath: IndexPath) {}
}
